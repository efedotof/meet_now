class AuthManager {
    constructor() {
        this.api = api;
        this.initElements();
        this.bindEvents();
        this.checkAuthState();
        this.api.addAuthListener(this.onAuthChange.bind(this));
    }

    initElements() {
        this.elements = {
            authButtons: document.getElementById('auth-buttons'),
            userProfile: document.getElementById('user-profile'),
            loginBtn: document.getElementById('login-btn'),
            registerBtn: document.getElementById('register-btn'),
            logoutBtn: document.getElementById('logout-btn'),
            usernameSpan: document.getElementById('username'),
            loginModal: document.getElementById('login-modal'),
            registerModal: document.getElementById('register-modal'),
            loginForm: document.getElementById('login-form'),
            registerForm: document.getElementById('register-form'),
            modalCloses: document.querySelectorAll('.modal-close'),
            modals: document.querySelectorAll('.modal')
        };
    }

    bindEvents() {
        this.elements.loginBtn?.addEventListener('click', () => this.showLoginModal());
        this.elements.registerBtn?.addEventListener('click', () => this.showRegisterModal());
        this.elements.logoutBtn?.addEventListener('click', () => this.logout());

        this.elements.loginForm?.addEventListener('submit', (e) => this.handleLogin(e));
        this.elements.registerForm?.addEventListener('submit', (e) => this.handleRegister(e));

        this.elements.modalCloses.forEach(closeBtn => {
            closeBtn.addEventListener('click', () => this.hideAllModals());
        });

        this.elements.modals.forEach(modal => {
            modal.addEventListener('click', (e) => {
                if (e.target === modal) {
                    this.hideAllModals();
                }
            });
        });

        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.hideAllModals();
            }
        });
    }

    onAuthChange(isAuthenticated) {
        if (isAuthenticated) {
            this.showUserProfile();
            if (window.gamesManager) {
                setTimeout(() => window.gamesManager.loadGames(), 100);
            }
        } else {
            this.showAuthButtons();
        }
    }

    checkAuthState() {
        if (this.api.isAuthenticated()) {
            this.showUserProfile();
        } else {
            this.showAuthButtons();
        }
    }

    showAuthButtons() {
        if (this.elements.authButtons) this.elements.authButtons.style.display = 'flex';
        if (this.elements.userProfile) this.elements.userProfile.style.display = 'none';
    }

    showUserProfile() {
        const userInfo = this.api.getUserInfo();
        if (userInfo && this.elements.usernameSpan) {
            if (userInfo.username) {
                this.elements.usernameSpan.textContent = userInfo.username;
            } else if (userInfo.sub) {
                this.elements.usernameSpan.textContent = userInfo.sub;
            } else if (userInfo.name) {
                this.elements.usernameSpan.textContent = userInfo.name;
            } else {
                this.elements.usernameSpan.textContent = 'Пользователь';
            }
        }
        
        if (this.elements.authButtons) this.elements.authButtons.style.display = 'none';
        if (this.elements.userProfile) this.elements.userProfile.style.display = 'block';
    }

    showLoginModal() {
        this.hideAllModals();
        if (this.elements.loginModal) {
            this.elements.loginModal.style.display = 'block';
            const usernameInput = document.getElementById('login-username');
            if (usernameInput) usernameInput.focus();
        }
    }

    showRegisterModal() {
        this.hideAllModals();
        if (this.elements.registerModal) {
            this.elements.registerModal.style.display = 'block';
            const usernameInput = document.getElementById('reg-username');
            if (usernameInput) usernameInput.focus();
        }
    }

    hideAllModals() {
        this.elements.modals.forEach(modal => {
            modal.style.display = 'none';
        });
    }

    async handleLogin(e) {
        e.preventDefault();
        const username = document.getElementById('login-username')?.value;
        const password = document.getElementById('login-password')?.value;

        if (!username || !password) {
            this.showMessage('Заполните все поля', 'error');
            return;
        }

        try {
            const data = await this.api.login({ username, password });
            this.showUserProfile();
            this.hideAllModals();
            this.showMessage('Успешный вход!', 'success');
        } catch (error) {
            this.showMessage(error.message || 'Ошибка при входе', 'error');
        }
    }

    async handleRegister(e) {
        e.preventDefault();
        const userData = {
            username: document.getElementById('reg-username')?.value || '',
            email: document.getElementById('reg-email')?.value || '',
            password: document.getElementById('reg-password')?.value || '',
            firstname: document.getElementById('reg-firstname')?.value || '',
            subname: document.getElementById('reg-subname')?.value || '',
            description: document.getElementById('reg-description')?.value || '',
            city: document.getElementById('reg-city')?.value || '',
            age: parseInt(document.getElementById('reg-age')?.value) || 0,
            purposes: [],
            interests: [],
            isSearchable: document.getElementById('reg-searchable')?.checked || false,
            floor: document.getElementById('reg-floor')?.value || ''
        };

        if (!userData.username || !userData.email || !userData.password) {
            this.showMessage('Заполните обязательные поля', 'error');
            return;
        }

        try {
            await this.api.register(userData);
            await this.api.login({ username: userData.username, password: userData.password });
            this.showUserProfile();
            this.hideAllModals();
            this.showMessage('Регистрация успешна! Добро пожаловать!', 'success');
        } catch (error) {
            this.showMessage(error.message || 'Ошибка при регистрации', 'error');
        }
    }

    async logout() {
        try {
            await this.api.logout();
            this.showAuthButtons();
            this.showMessage('Вы успешно вышли из системы', 'success');
        } catch (error) {
            console.error('Logout error:', error);
            this.showMessage('Ошибка при выходе', 'error');
        }
    }

    showMessage(text, type = 'info') {
        const existingMessages = document.querySelectorAll('.message');
        existingMessages.forEach(msg => msg.remove());

        const message = document.createElement('div');
        message.className = `message ${type}`;
        message.innerHTML = `
            <i class="fas fa-${type === 'success' ? 'check-circle' :
                type === 'error' ? 'exclamation-circle' :
                type === 'warning' ? 'exclamation-triangle' : 'info-circle'}"></i>
            <span>${text}</span>
        `;

        document.body.appendChild(message);
        setTimeout(() => message.remove(), 5000);
    }
}