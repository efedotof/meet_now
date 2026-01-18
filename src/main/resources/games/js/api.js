// api.js
const API_CONFIG = {
    BASE_URL: 'https://api.mnapp.ru/api/v1',
    ENDPOINTS: {
        REGISTER: '/auth/register',
        LOGIN: '/auth/login',
        LOGOUT: '/auth/logout',
        GAMES_LIST: '/games/list',
        PRESIGNED_URL: '/uploads/presigned-url'
    }
};

class ApiService {
    constructor() {
        this.token = localStorage.getItem('token');
        this.imageCache = new Map();
        this.authListeners = [];
    }

    setToken(token) {
        this.token = token;
        localStorage.setItem('token', token);
        this.notifyAuthChange(true);
    }

    clearToken() {
        this.token = null;
        localStorage.removeItem('token');
        localStorage.removeItem('user');
        this.imageCache.clear();
        this.notifyAuthChange(false);
    }

    notifyAuthChange(isAuthenticated) {
        this.authListeners.forEach(listener => listener(isAuthenticated));
    }

    addAuthListener(callback) {
        this.authListeners.push(callback);
    }

    removeAuthListener(callback) {
        this.authListeners = this.authListeners.filter(listener => listener !== callback);
    }

    async request(endpoint, method = 'GET', data = null, requiresAuth = false) {
        const url = `${API_CONFIG.BASE_URL}${endpoint}`;
        const headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        };

        if (requiresAuth) {
            if (this.token) {
                headers['Authorization'] = `Bearer ${this.token}`;
            } else {
                throw new Error('Требуется авторизация. Пожалуйста, войдите в систему.');
            }
        }

        const config = {
            method,
            headers,
            mode: 'cors'
        };

        if (data && method !== 'GET' && method !== 'HEAD') {
            config.body = JSON.stringify(data);
        }

        try {
            const response = await fetch(url, config);

            if (!response.ok) {
                let errorMessage = `HTTP error! status: ${response.status}`;

                try {
                    const errorData = await response.json().catch(() => ({}));
                    errorMessage = errorData.message || errorData.error || errorMessage;

                    if (response.status === 401 || response.status === 403) {
                        this.clearToken();
                        errorMessage = 'Сессия истекла. Пожалуйста, войдите снова.';
                    }
                } catch (e) {
                    console.warn('Could not parse error response:', e);
                }

                throw new Error(errorMessage);
            }

            const text = await response.text();

            try {
                const json = JSON.parse(text);
                return json;
            } catch (e) {
                return text;
            }
        } catch (error) {
            console.error('API Error:', error);

            if (error.name === 'TypeError' && error.message.includes('fetch')) {
                throw new Error('Сетевая ошибка. Проверьте подключение к интернету.');
            }

            throw error;
        }
    }

    async register(userData) {
        try {
            const cleanUserData = {};
            Object.keys(userData).forEach(key => {
                if (userData[key] !== '' && userData[key] !== null && userData[key] !== undefined) {
                    cleanUserData[key] = userData[key];
                }
            });

            const response = await this.request(API_CONFIG.ENDPOINTS.REGISTER, 'POST', cleanUserData);
            return response;
        } catch (error) {
            console.error('Registration error:', error);
            throw error;
        }
    }

    async login(credentials) {
        try {
            const response = await this.request(API_CONFIG.ENDPOINTS.LOGIN, 'POST', credentials);

            let token = null;
            let userData = null;

            if (response && response.token) {
                token = response.token;
                userData = { ...response };
                delete userData.token;
            } else if (response && response.data && response.data.token) {
                token = response.data.token;
                userData = response.data;
                delete userData.token;
            } else if (typeof response === 'object') {
                token = response.token || response.accessToken || response.access_token;
                userData = { ...response };
                delete userData.token;
                delete userData.accessToken;
                delete userData.access_token;
            }

            if (token) {
                this.setToken(token);
                const userInfo = userData || { username: credentials.username };
                localStorage.setItem('user', JSON.stringify(userInfo));
                return { success: true, token, user: userInfo };
            } else {
                throw new Error('Не удалось получить токен из ответа сервера');
            }
        } catch (error) {
            console.error('Login error:', error);
            throw error;
        }
    }

    async logout() {
        try {
            if (this.token) {
                await this.request(API_CONFIG.ENDPOINTS.LOGOUT, 'POST', null, true);
            }
        } catch (error) {
            console.log('Logout request failed:', error);
        } finally {
            this.clearToken();
        }

        return { success: true };
    }

    async getGames() {
        const games = await this.request(API_CONFIG.ENDPOINTS.GAMES_LIST, 'GET', null, true);

        if (games && Array.isArray(games)) {
            const gamesWithUrls = await Promise.all(games.map(async (game) => {
                if (game.thumbnailUrl) {
                    try {
                        const presignedUrl = await this.getPresignedUrl(game.thumbnailUrl);
                        return {
                            ...game,
                            thumbnailUrl: presignedUrl || null
                        };
                    } catch (error) {
                        console.error(`Error getting presigned URL for game ${game.gameName}:`, error);
                        return {
                            ...game,
                            thumbnailUrl: null
                        };
                    }
                }
                return game;
            }));

            return gamesWithUrls;
        }

        return games || [];
    }

    async getPresignedUrl(fileUrl) {
        if (!fileUrl || fileUrl.trim() === '') {
            return null;
        }

        if (this.imageCache.has(fileUrl)) {
            const cached = this.imageCache.get(fileUrl);
            if (Date.now() < cached.expiresAt) {
                return cached.url;
            } else {
                this.imageCache.delete(fileUrl);
            }
        }

        if (fileUrl.startsWith('data:')) {
            return fileUrl;
        }

        try {
            let s3Key = fileUrl;

            if (fileUrl.includes('storage.beget.cloud')) {
                try {
                    const urlObj = new URL(fileUrl);
                    const pathParts = urlObj.pathname.split('/');

                    if (pathParts.length >= 3) {
                        s3Key = pathParts.slice(2).join('/');
                    }
                } catch (e) {
                    console.log('Could not parse URL, using original:', fileUrl);
                }
            }

            const response = await this.request(
                `${API_CONFIG.ENDPOINTS.PRESIGNED_URL}?fileUrl=${encodeURIComponent(s3Key)}`,
                'GET',
                null,
                true
            );

            let presignedUrl = null;

            if (typeof response === 'string') {
                presignedUrl = response.trim();
            } else if (response && typeof response === 'object') {
                presignedUrl = response.url || response.presignedUrl || response.data;
                if (presignedUrl && typeof presignedUrl !== 'string') {
                    presignedUrl = null;
                }
            }

            if (presignedUrl) {
                console.log('Presigned URL for', s3Key, '->', presignedUrl.substring(0, 100) + '...');

                this.imageCache.set(fileUrl, {
                    url: presignedUrl,
                    expiresAt: Date.now() + 50 * 60 * 1000
                });
                return presignedUrl;
            }

            return null;
        } catch (error) {
            console.error('Error getting presigned URL for', fileUrl, ':', error);
            return null;
        }
    }

    async getPresignedUrls(fileUrls) {
        const results = {};
        const promises = [];

        for (const fileUrl of fileUrls) {
            if (!fileUrl || fileUrl.trim() === '') continue;

            if (this.imageCache.has(fileUrl)) {
                const cached = this.imageCache.get(fileUrl);
                if (Date.now() < cached.expiresAt) {
                    results[fileUrl] = cached.url;
                    continue;
                } else {
                    this.imageCache.delete(fileUrl);
                }
            }

            if (fileUrl.startsWith('data:')) {
                results[fileUrl] = fileUrl;
            } else {
                promises.push(
                    this.getPresignedUrl(fileUrl).then(url => {
                        if (url) {
                            results[fileUrl] = url;
                        }
                    })
                );
            }
        }

        if (promises.length > 0) {
            await Promise.all(promises);
        }

        return results;
    }

    isAuthenticated() {
        return !!this.token;
    }

    getUserInfo() {
        try {
            const userData = localStorage.getItem('user');
            if (userData) {
                const user = JSON.parse(userData);
                return user;
            }

            if (this.token) {
                try {
                    const payload = this.token.split('.')[1];
                    if (payload) {
                        const decoded = JSON.parse(atob(payload));
                        return decoded;
                    }
                } catch (e) {
                    console.warn('Cannot decode JWT token:', e);
                }
            }

            return null;
        } catch (error) {
            console.error('Error getting user info:', error);
            return null;
        }
    }
}

const api = new ApiService();

