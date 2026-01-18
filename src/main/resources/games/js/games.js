class GamesManager {
    constructor() {
        this.api = api;
        this.gamesContainer = document.getElementById('games-container');
        this.loadingElement = document.getElementById('loading');
        this.errorElement = document.getElementById('error-message');
        this.retryBtn = document.getElementById('retry-btn');
        this.games = [];
        
        this.bindEvents();
        
        if (this.api.isAuthenticated()) {
            this.loadGames();
        } else {
            this.showAuthRequired();
        }
    }

    bindEvents() {
        this.retryBtn?.addEventListener('click', () => this.loadGames());
        this.api.addAuthListener((isAuthenticated) => {
            if (isAuthenticated) {
                this.loadGames();
            } else {
                this.showAuthRequired();
            }
        });
    }

    async loadGames() {
        this.showLoading();
        this.hideError();

        try {
            if (!this.api.isAuthenticated()) {
                throw new Error('Для просмотра игр необходимо авторизоваться');
            }
            
            this.games = await this.api.getGames();
            await this.displayGames(this.games);
            this.hideLoading();
        } catch (error) {
            console.error('Error loading games:', error);
            this.hideLoading();
            
            if (error.message.includes('авторизоваться') || error.message.includes('401') || error.message.includes('403')) {
                this.showAuthRequired();
            } else {
                this.showError(error.message || 'Не удалось загрузить игры');
            }
        }
    }

    async displayGames(games) {
        if (!games || games.length === 0) {
            this.showNoGames();
            return;
        }

        const validGames = games.filter(game => game && game.gameName && game.gameUrl);
        if (validGames.length === 0) {
            this.showNoGames();
            return;
        }

        this.gamesContainer.innerHTML = validGames.map((game, index) => this.createGameCard(game, index)).join('');
        await this.loadGameImages(validGames);
        this.bindGameEvents();
    }

    createGameCard(game, index) {
        return `
            <div class="game-card" data-game-index="${index}">
                <div class="game-thumbnail-container">
                    <div class="image-placeholder" id="game-image-placeholder-${index}">
                        <i class="fas fa-gamepad"></i>
                    </div>
                    <img src="" 
                         alt="${game.gameName || 'Игра'}" 
                         class="game-thumbnail"
                         id="game-image-${index}"
                         data-original-src="${game.thumbnailUrl || ''}"
                         style="display: none;">
                    ${game.gameType ? `<span class="game-type-badge">${game.gameType}</span>` : ''}
                </div>
                
                <div class="game-content">
                    <h3 class="game-title">${game.gameName || 'Без названия'}</h3>
                    <p class="game-description">${game.gameDescription || 'Увлекательная мини-игра для общения и развлечения.'}</p>
                    
                    <div class="game-footer">
                        <a href="${game.gameUrl}" class="btn btn-primary play-btn" data-game-url="${game.gameUrl}">
                            <i class="fas fa-play"></i> Играть
                        </a>
                        <div class="game-meta">
                            <span class="game-author">MNA</span>
                            ${game.gameType ? `<span class="game-type">${game.gameType}</span>` : ''}
                        </div>
                    </div>
                </div>
            </div>
        `;
    }

    async loadGameImages(games) {
        const loadPromises = games.map((game, index) => {
            return new Promise((resolve) => {
                const placeholder = document.getElementById(`game-image-placeholder-${index}`);
                const imgElement = document.getElementById(`game-image-${index}`);
                
                if (!imgElement || !game.thumbnailUrl) {
                    if (placeholder) placeholder.style.display = 'flex';
                    resolve();
                    return;
                }

                const img = new Image();
                img.onload = () => {
                    imgElement.src = game.thumbnailUrl;
                    imgElement.style.display = 'block';
                    if (placeholder) placeholder.style.display = 'none';
                    imgElement.style.opacity = '0';
                    setTimeout(() => {
                        imgElement.style.transition = 'opacity 0.3s ease';
                        imgElement.style.opacity = '1';
                    }, 10);
                    resolve();
                };
                img.onerror = () => {
                    console.warn(`Failed to load image for game: ${game.gameName}`);
                    if (placeholder) placeholder.style.display = 'flex';
                    resolve();
                };
                img.src = game.thumbnailUrl;
            });
        });

        await Promise.all(loadPromises);
    }

    bindGameEvents() {
        document.querySelectorAll('.play-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                const url = btn.getAttribute('data-game-url');
                this.openGame(url);
            });
        });
    }

    openGame(url) {
        if (!this.api.isAuthenticated()) {
            if (window.authManager) {
                window.authManager.showMessage('Для игры необходимо авторизоваться', 'warning');
                window.authManager.showLoginModal();
            }
            return;
        }

        if (!url || url === '#' || url === 'undefined') {
            if (window.authManager) {
                window.authManager.showMessage('Ссылка на игру недействительна', 'error');
            }
            return;
        }

        try {
            const token = this.api.token;
            if (!token) {
                throw new Error('Токен не найден');
            }

            const separator = url.includes('?') ? '&' : '?';
            const gameUrlWithToken = `${url}${separator}token=${encodeURIComponent(token)}`;
            
            window.open(gameUrlWithToken, '_blank', 'noopener,noreferrer');
        } catch (error) {
            console.error('Error opening game:', error);
            if (window.authManager) {
                window.authManager.showMessage('Не удалось открыть игру', 'error');
            }
        }
    }

    showLoading() {
        if (this.loadingElement) this.loadingElement.style.display = 'flex';
        if (this.gamesContainer) this.gamesContainer.innerHTML = '';
        if (this.errorElement) this.errorElement.style.display = 'none';
    }

    hideLoading() {
        if (this.loadingElement) this.loadingElement.style.display = 'none';
    }

    showNoGames() {
        if (this.gamesContainer) {
            this.gamesContainer.innerHTML = `
                <div class="no-games">
                    <i class="fas fa-gamepad"></i>
                    <h3>Игры скоро появятся!</h3>
                    <p>На данный момент игры находятся в разработке.</p>
                    <p style="margin-top: 10px; font-size: 0.9rem;">Или попробуйте обновить страницу.</p>
                </div>
            `;
        }
    }

    showAuthRequired() {
        if (this.errorElement) {
            this.errorElement.innerHTML = `
                <i class="fas fa-exclamation-triangle"></i>
                <p>Для доступа к играм необходимо войти в систему</p>
                <div style="display: flex; gap: 10px; justify-content: center; margin-top: 20px;">
                    <button id="login-from-error" class="btn btn-primary">
                        <i class="fas fa-sign-in-alt"></i> Войти
                    </button>
                    <button id="register-from-error" class="btn btn-outline">
                        <i class="fas fa-user-plus"></i> Регистрация
                    </button>
                </div>
            `;
            this.errorElement.style.display = 'block';
            
            document.getElementById('login-from-error')?.addEventListener('click', () => {
                if (window.authManager) window.authManager.showLoginModal();
            });
            
            document.getElementById('register-from-error')?.addEventListener('click', () => {
                if (window.authManager) window.authManager.showRegisterModal();
            });
        }
        
        if (this.gamesContainer) this.gamesContainer.innerHTML = '';
    }

    showError(message = 'Не удалось загрузить игры. Пожалуйста, попробуйте позже.') {
        if (this.errorElement) {
            this.errorElement.innerHTML = `
                <i class="fas fa-exclamation-triangle"></i>
                <p>${message}</p>
                <button id="retry-btn" class="btn btn-outline">Попробовать снова</button>
            `;
            this.errorElement.style.display = 'block';
            
            const retryBtn = document.getElementById('retry-btn');
            if (retryBtn) retryBtn.addEventListener('click', () => this.loadGames());
        }
    }

    hideError() {
        if (this.errorElement) this.errorElement.style.display = 'none';
    }

    refreshGames() {
        this.loadGames();
    }
}