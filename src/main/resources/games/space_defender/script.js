const CONFIG = {
    API_BASE_URL: 'https://api.mnapp.ru',
    MAX_ASTEROIDS: 20,
    MAX_PROJECTILES: 30,
    MAX_EXPLOSIONS: 10,
    MAX_CLICK_EFFECTS: 8,
    STAR_COUNT: 80,
    ASTEROID_SPAWN_INTERVAL: 1200
};

const params = new URLSearchParams(window.location.search);
const token = params.get('token');
const chatId = params.get('chatId');
const gameType = 'space_defender';

const elements = Object.freeze({
    gameContainer: document.getElementById('game-container'),
    player: document.getElementById('player'),
    score: document.getElementById('score'),
    lives: document.getElementById('lives'),
    level: document.getElementById('level'),
    playTime: document.getElementById('play-time'),
    startBtn: document.getElementById('start-btn'),
    pauseBtn: document.getElementById('pause-btn'),
    resetBtn: document.getElementById('reset-btn'),
    gameOverScreen: document.getElementById('game-over'),
    finalScore: document.getElementById('final-score'),
    finalTime: document.getElementById('final-time'),
    finalLevel: document.getElementById('final-level'),
    restartBtn: document.getElementById('restart-btn'),
    starsBg: document.getElementById('stars-bg'),
    leftBtn: document.getElementById('left-btn'),
    rightBtn: document.getElementById('right-btn'),
    fireBtn: document.getElementById('fire-btn'),
    tokenStatus: document.getElementById('token-status'),
    completionModal: document.getElementById('completion-modal'),
    savedScore: document.getElementById('saved-score'),
    continueBtn: document.getElementById('continue-btn'),
    burgerMenuBtn: document.getElementById('burger-menu-btn'),
    burgerMenu: document.getElementById('burger-menu'),
    burgerMenuClose: document.getElementById('burger-menu-close'),
    burgerHighScore: document.getElementById('burger-high-score'),
    burgerPlayTime: document.getElementById('burger-play-time'),
    burgerShotsPerSecond: document.getElementById('burger-shots-per-second'),
    burgerProgressBar: document.getElementById('burger-progress-bar'),
    burgerProgressText: document.getElementById('burger-progress-text'),
    burgerTokenStatus: document.getElementById('burger-token-status')
});

let state = {
    gameActive: false,
    gamePaused: false,
    score: 0,
    lives: 3,
    level: 1,
    playerPosition: 50,
    stars: [],
    asteroids: [],
    projectiles: [],
    explosions: [],
    clickEffects: [],
    resultsSent: false,
    pendingScore: 0,
    startTime: 0,
    playTime: 0,
    highScore: parseInt(localStorage.getItem('space_defender_highscore')) || 0,
    shotsHistory: [],
    shotsPerSecond: 0,
    burgerMenuOpen: false,
    gameLoopId: 0,
    asteroidIntervalId: 0,
    statsIntervalId: 0,
    lastFrameTime: 0,
    gameContainerRect: null,
    tokenValid: false
};

const objectPool = {
    asteroids: [],
    projectiles: [],
    explosions: [],
    clickEffects: [],
    
    getAsteroid() {
        if (this.asteroids.length > 0) {
            return this.asteroids.pop();
        }
        const asteroid = document.createElement('div');
        asteroid.className = 'asteroid';
        asteroid.style.position = 'absolute';
        return asteroid;
    },
    
    returnAsteroid(asteroid) {
        asteroid.style.display = 'none';
        this.asteroids.push(asteroid);
    },
    
    getProjectile() {
        if (this.projectiles.length > 0) {
            return this.projectiles.pop();
        }
        const projectile = document.createElement('div');
        projectile.className = 'projectile';
        projectile.style.position = 'absolute';
        return projectile;
    },
    
    returnProjectile(projectile) {
        projectile.style.display = 'none';
        this.projectiles.push(projectile);
    },
    
    getExplosion() {
        if (this.explosions.length > 0) {
            return this.explosions.pop();
        }
        const explosion = document.createElement('div');
        explosion.className = 'explosion';
        explosion.style.position = 'absolute';
        return explosion;
    },
    
    returnExplosion(explosion) {
        explosion.style.display = 'none';
        this.explosions.push(explosion);
    },
    
    getClickEffect() {
        if (this.clickEffects.length > 0) {
            return this.clickEffects.pop();
        }
        const effect = document.createElement('div');
        effect.className = 'click-effect';
        effect.style.position = 'absolute';
        effect.style.pointerEvents = 'none';
        effect.style.zIndex = '100';
        return effect;
    },
    
    returnClickEffect(effect) {
        effect.style.display = 'none';
        this.clickEffects.push(effect);
    }
};

async function initGame() {
    if (!token || token.trim() === '') {
        elements.tokenStatus.textContent = 'Демо-режим';
        elements.tokenStatus.style.color = '#ff2d75';
        if (elements.burgerTokenStatus) {
            elements.burgerTokenStatus.textContent = 'Токен: Демо-режим';
        }
        setTimeout(() => {
            if (!token) {
                alert('Для сохранения результатов требуется токен авторизации.\n\nДобавьте параметр ?token=your_token в URL\n\nСейчас игра работает в демо-режиме');
            }
        }, 1000);
        startGame();
        return;
    }

    await validateToken();
    loadSavedState();
    startGame();
}

async function validateToken() {
    try {
        const response = await fetch(`${CONFIG.API_BASE_URL}/api/v1/auth/token/validate-token`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
        });
        
        if (response.ok) {
            state.tokenValid = true;
            elements.tokenStatus.textContent = 'Токен валиден';
            elements.tokenStatus.style.color = '#00ff88';
            if (elements.burgerTokenStatus) {
                elements.burgerTokenStatus.textContent = 'Токен: Валиден';
            }
        } else {
            throw new Error('Токен невалиден');
        }
    } catch (error) {
        state.tokenValid = false;
        elements.tokenStatus.textContent = 'Токен невалиден';
        elements.tokenStatus.style.color = '#ffd700';
        if (elements.burgerTokenStatus) {
            elements.burgerTokenStatus.textContent = 'Токен: Невалиден';
        }
        console.error('Token validation error:', error);
    }
}

function loadSavedState() {
    const savedState = localStorage.getItem('space_defender_state');
    if (savedState) {
        try {
            const parsed = JSON.parse(savedState);
            state.score = parsed.score || 0;
            state.lives = parsed.lives || 3;
            state.level = parsed.level || 1;
            state.playerPosition = parsed.playerPosition || 50;
            state.highScore = parsed.highScore || 0;
        } catch (e) { }
    }

    const pendingResults = localStorage.getItem('pending_results_space');
    if (pendingResults) {
        try {
            const results = JSON.parse(pendingResults);
            state.pendingScore = results.score || 0;
            if (state.pendingScore > 0) {
                setTimeout(sendPendingResults, 2000);
            }
        } catch (e) { }
    }
}

function startGame() {
    clearAllGameObjects();
    
    state.score = 0;
    state.lives = 3;
    state.level = 1;
    state.playerPosition = 50;
    state.resultsSent = false;
    state.startTime = Date.now();
    state.playTime = 0;
    state.shotsHistory = [];
    state.shotsPerSecond = 0;

    updateUI();
    updatePlayerPosition();

    elements.gameOverScreen.classList.remove('active');
    elements.completionModal.classList.remove('active');
    
    state.gameActive = true;
    state.gamePaused = false;
    elements.pauseBtn.innerHTML = '<i class="fas fa-pause"></i> Пауза';

    cancelAnimationFrame(state.gameLoopId);
    state.gameLoopId = requestAnimationFrame(gameLoop);

    clearInterval(state.asteroidIntervalId);
    state.asteroidIntervalId = setInterval(createAsteroid, CONFIG.ASTEROID_SPAWN_INTERVAL);

    clearInterval(state.statsIntervalId);
    state.statsIntervalId = setInterval(updateStats, 1000);

    createStars();
    setupEventListeners();
    
    updateGameContainerRect();
}

function clearAllGameObjects() {
    state.asteroids.forEach(obj => {
        if (obj.element && obj.element.parentNode) {
            objectPool.returnAsteroid(obj.element);
        }
    });
    
    state.projectiles.forEach(obj => {
        if (obj.element && obj.element.parentNode) {
            objectPool.returnProjectile(obj.element);
        }
    });
    
    state.explosions.forEach(obj => {
        if (obj.element && obj.element.parentNode) {
            objectPool.returnExplosion(obj.element);
        }
    });
    
    state.clickEffects.forEach(obj => {
        if (obj.element && obj.element.parentNode) {
            objectPool.returnClickEffect(obj.element);
        }
    });
    
    state.asteroids = [];
    state.projectiles = [];
    state.explosions = [];
    state.clickEffects = [];
}

function setupEventListeners() {
    elements.gameContainer.removeEventListener('mousemove', handleMouseMove);
    elements.gameContainer.removeEventListener('touchmove', handleTouchMove);
    elements.gameContainer.removeEventListener('click', handleClick);
    elements.gameContainer.removeEventListener('touchend', handleTouchEnd);
    
    elements.gameContainer.addEventListener('mousemove', handleMouseMove, { passive: true });
    elements.gameContainer.addEventListener('touchmove', handleTouchMove, { passive: false });
    elements.gameContainer.addEventListener('click', handleClick, { passive: true });
    elements.gameContainer.addEventListener('touchend', handleTouchEnd, { passive: false });
    
    elements.startBtn.onclick = () => {
        if (!state.gameActive) {
            startGame();
        }
        state.gamePaused = false;
        elements.pauseBtn.innerHTML = '<i class="fas fa-pause"></i> Пауза';
    };
    
    elements.pauseBtn.onclick = () => {
        if (state.gameActive) {
            state.gamePaused = !state.gamePaused;
            elements.pauseBtn.innerHTML = state.gamePaused ? 
                '<i class="fas fa-play"></i> Продолжить' : 
                '<i class="fas fa-pause"></i> Пауза';
        }
    };
    
    elements.resetBtn.onclick = () => startGame();
    elements.restartBtn.onclick = () => startGame();
    elements.continueBtn.onclick = () => {
        elements.completionModal.classList.remove('active');
    };
    
    elements.leftBtn.ontouchstart = (e) => {
        e.preventDefault();
        movePlayer(-15);
    };
    
    elements.rightBtn.ontouchstart = (e) => {
        e.preventDefault();
        movePlayer(15);
    };
    
    elements.fireBtn.ontouchstart = (e) => {
        e.preventDefault();
        createProjectile();
    };
    
    elements.burgerMenuBtn.onclick = toggleBurgerMenu;
    elements.burgerMenuClose.onclick = toggleBurgerMenu;
    elements.burgerMenu.onclick = (e) => {
        if (e.target === elements.burgerMenu) {
            toggleBurgerMenu();
        }
    };
    
    window.addEventListener('beforeunload', handleBeforeUnload);
    window.addEventListener('pagehide', handlePageHide);
    window.addEventListener('visibilitychange', handleVisibilityChange);
    
    document.addEventListener('keydown', handleKeyDown);
}

function handleKeyDown(e) {
    if (e.key === 'Escape' && state.burgerMenuOpen) {
        toggleBurgerMenu();
    } else if (e.key === ' ' && state.gameActive && !state.gamePaused) {
        e.preventDefault();
        createProjectile();
    } else if (e.key === 'ArrowLeft') {
        movePlayer(-15);
    } else if (e.key === 'ArrowRight') {
        movePlayer(15);
    }
}

function toggleBurgerMenu() {
    state.burgerMenuOpen = !state.burgerMenuOpen;
    if (state.burgerMenuOpen) {
        elements.burgerMenu.classList.add('active');
        document.body.style.overflow = 'hidden';
        updateBurgerMenu();
    } else {
        elements.burgerMenu.classList.remove('active');
        document.body.style.overflow = '';
    }
}

function createStars() {
    elements.starsBg.innerHTML = '';
    state.stars = [];
    
    for (let i = 0; i < CONFIG.STAR_COUNT; i++) {
        const star = document.createElement('div');
        star.classList.add('star');
        
        const size = Math.random() * 2 + 1;
        const posX = Math.random() * 100;
        const posY = Math.random() * 100;
        const opacity = Math.random() * 0.5 + 0.3;
        
        star.style.width = `${size}px`;
        star.style.height = `${size}px`;
        star.style.left = `${posX}%`;
        star.style.top = `${posY}%`;
        star.style.opacity = opacity;
        
        elements.starsBg.appendChild(star);
    }
}

function createAsteroid() {
    if (!state.gameActive || state.gamePaused || state.asteroids.length >= CONFIG.MAX_ASTEROIDS) {
        return;
    }
    
    const asteroid = objectPool.getAsteroid();
    const size = Math.random() * 50 + 30;
    
    asteroid.style.width = `${size}px`;
    asteroid.style.height = `${size}px`;
    asteroid.style.left = `${Math.random() * 85 + 7.5}%`;
    asteroid.style.top = '-120px';
    asteroid.style.display = 'block';
    
    if (!asteroid.parentNode) {
        elements.gameContainer.appendChild(asteroid);
    }
    
    const asteroidObj = {
        element: asteroid,
        x: parseFloat(asteroid.style.left),
        y: -120,
        speed: Math.random() * 2 + 1 + state.level * 0.2,
        size: size,
        rotation: Math.random() * 5 - 2.5,
        rotationValue: 0
    };
    
    state.asteroids.push(asteroidObj);
}

function createProjectile() {
    if (!state.gameActive || state.gamePaused || state.projectiles.length >= CONFIG.MAX_PROJECTILES) {
        return;
    }
    
    const projectile = objectPool.getProjectile();
    
    projectile.style.left = `calc(${state.playerPosition}% - 3px)`;
    projectile.style.bottom = '180px';
    projectile.style.display = 'block';
    
    if (!projectile.parentNode) {
        elements.gameContainer.appendChild(projectile);
    }
    
    const projectileObj = {
        element: projectile,
        x: state.playerPosition,
        y: 180,
        speed: 12
    };
    
    state.projectiles.push(projectileObj);
    
    state.shotsHistory.push(Date.now());
    
    if (state.clickEffects.length < CONFIG.MAX_CLICK_EFFECTS) {
        createClickEffect(projectile.style.left, '180px', '⚡');
    }
}

function gameLoop(timestamp) {
    if (!state.gameActive) return;
    
    const deltaTime = timestamp - state.lastFrameTime;
    if (deltaTime < 16) {
        state.gameLoopId = requestAnimationFrame(gameLoop);
        return;
    }
    state.lastFrameTime = timestamp;
    
    if (state.gamePaused) {
        state.gameLoopId = requestAnimationFrame(gameLoop);
        return;
    }
    
    updateGameContainerRect();
    updateAsteroids();
    updateProjectiles();
    updateEffects();
    
    state.gameLoopId = requestAnimationFrame(gameLoop);
}

function updateGameContainerRect() {
    state.gameContainerRect = elements.gameContainer.getBoundingClientRect();
}

function updateAsteroids() {
    const playerRect = elements.player.getBoundingClientRect();
    
    for (let i = state.asteroids.length - 1; i >= 0; i--) {
        const asteroid = state.asteroids[i];
        
        if (!asteroid.element.parentNode) {
            state.asteroids.splice(i, 1);
            continue;
        }
        
        asteroid.y += asteroid.speed;
        asteroid.element.style.top = `${asteroid.y}px`;
        
        asteroid.rotationValue += asteroid.rotation;
        asteroid.element.style.transform = `rotate(${asteroid.rotationValue}deg)`;
        
        const asteroidRect = asteroid.element.getBoundingClientRect();
        
        if (checkCollision(playerRect, asteroidRect)) {
            objectPool.returnAsteroid(asteroid.element);
            state.asteroids.splice(i, 1);
            state.lives--;
            updateUI();
            
            createExplosion(
                asteroidRect.left + asteroidRect.width / 2,
                asteroidRect.top + asteroidRect.height / 2
            );
            
            if (state.clickEffects.length < CONFIG.MAX_CLICK_EFFECTS) {
                createClickEffect(asteroidRect.left, asteroidRect.top, '💥 -1');
            }
            
            if (state.lives <= 0) {
                endGame();
            }
            continue;
        }
        
        if (asteroid.y > state.gameContainerRect.height + 100) {
            objectPool.returnAsteroid(asteroid.element);
            state.asteroids.splice(i, 1);
        }
    }
}

function updateProjectiles() {
    for (let i = state.projectiles.length - 1; i >= 0; i--) {
        const projectile = state.projectiles[i];
        
        if (!projectile.element.parentNode) {
            state.projectiles.splice(i, 1);
            continue;
        }
        
        projectile.y += projectile.speed;
        projectile.element.style.bottom = `${projectile.y}px`;
        
        const projectileRect = projectile.element.getBoundingClientRect();
        
        for (let j = state.asteroids.length - 1; j >= 0; j--) {
            const asteroid = state.asteroids[j];
            const asteroidRect = asteroid.element.getBoundingClientRect();
            
            if (checkCollision(projectileRect, asteroidRect)) {
                objectPool.returnProjectile(projectile.element);
                state.projectiles.splice(i, 1);
                
                objectPool.returnAsteroid(asteroid.element);
                state.asteroids.splice(j, 1);
                
                createExplosion(
                    asteroidRect.left + asteroidRect.width / 2,
                    asteroidRect.top + asteroidRect.height / 2
                );
                
                if (state.clickEffects.length < CONFIG.MAX_CLICK_EFFECTS) {
                    createClickEffect(asteroidRect.left, asteroidRect.top, `+${Math.floor(10 * state.level)}`);
                }
                
                state.score += Math.floor(10 * state.level);
                if (state.score > state.highScore) {
                    state.highScore = state.score;
                    localStorage.setItem('space_defender_highscore', state.highScore);
                }
                
                if (state.score >= state.level * 100) {
                    state.level++;
                }
                
                updateUI();
                break;
            }
        }
        
        if (projectile.y > state.gameContainerRect.height + 100) {
            objectPool.returnProjectile(projectile.element);
            state.projectiles.splice(i, 1);
        }
    }
}

function updateEffects() {
    for (let i = state.explosions.length - 1; i >= 0; i--) {
        const explosion = state.explosions[i];
        if (!explosion.element.parentNode) {
            objectPool.returnExplosion(explosion.element);
            state.explosions.splice(i, 1);
        }
    }
    
    for (let i = state.clickEffects.length - 1; i >= 0; i--) {
        const effect = state.clickEffects[i];
        if (!effect.element.parentNode) {
            objectPool.returnClickEffect(effect.element);
            state.clickEffects.splice(i, 1);
        }
    }
}

function checkCollision(rect1, rect2) {
    return !(rect1.right < rect2.left || 
             rect1.left > rect2.right || 
             rect1.bottom < rect2.top || 
             rect1.top > rect2.bottom);
}

function createExplosion(x, y) {
    if (state.explosions.length >= CONFIG.MAX_EXPLOSIONS) {
        return;
    }
    
    const explosion = objectPool.getExplosion();
    
    explosion.style.left = `${x - 15}px`;
    explosion.style.top = `${y - 15}px`;
    explosion.style.width = '30px';
    explosion.style.height = '30px';
    explosion.style.display = 'block';
    
    if (!explosion.parentNode) {
        elements.gameContainer.appendChild(explosion);
    }
    
    state.explosions.push({ element: explosion });
    
    setTimeout(() => {
        if (explosion.parentNode) {
            objectPool.returnExplosion(explosion);
        }
    }, 800);
}

function createClickEffect(x, y, text) {
    const effect = objectPool.getClickEffect();
    
    effect.textContent = text;
    effect.style.left = x;
    effect.style.top = y;
    effect.style.display = 'block';
    
    const colors = ['#00d4ff', '#9d4edd', '#ff2d75', '#00ff88', '#ffd700'];
    const color = colors[Math.floor(Math.random() * colors.length)];
    effect.style.color = color;
    
    if (!effect.parentNode) {
        elements.gameContainer.appendChild(effect);
    }
    
    state.clickEffects.push({ element: effect });
    
    setTimeout(() => {
        if (effect.parentNode) {
            objectPool.returnClickEffect(effect);
        }
    }, 1000);
}

function handleMouseMove(e) {
    if (!state.gameActive || state.gamePaused) return;
    
    updateGameContainerRect();
    const relativeX = e.clientX - state.gameContainerRect.left;
    state.playerPosition = (relativeX / state.gameContainerRect.width) * 100;
    
    state.playerPosition = Math.max(5, Math.min(95, state.playerPosition));
    updatePlayerPosition();
}

function handleTouchMove(e) {
    if (!state.gameActive || state.gamePaused) return;
    
    e.preventDefault();
    const touch = e.touches[0];
    updateGameContainerRect();
    const relativeX = touch.clientX - state.gameContainerRect.left;
    state.playerPosition = (relativeX / state.gameContainerRect.width) * 100;
    
    state.playerPosition = Math.max(5, Math.min(95, state.playerPosition));
    updatePlayerPosition();
}

function handleClick() {
    if (state.gameActive && !state.gamePaused) createProjectile();
}

function handleTouchEnd(e) {
    if (state.gameActive && !state.gamePaused) {
        e.preventDefault();
        createProjectile();
    }
}

function movePlayer(amount) {
    if (!state.gameActive || state.gamePaused) return;
    
    state.playerPosition += amount;
    state.playerPosition = Math.max(5, Math.min(95, state.playerPosition));
    updatePlayerPosition();
}

function updatePlayerPosition() {
    elements.player.style.left = `${state.playerPosition}%`;
}

function updateUI() {
    elements.score.textContent = formatNumber(state.score);
    elements.lives.textContent = state.lives;
    elements.level.textContent = state.level;
    
    const minutes = Math.floor(state.playTime / 60);
    const seconds = state.playTime % 60;
    elements.playTime.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
}

function updateStats() {
    if (!state.gameActive) return;
    
    state.playTime = Math.floor((Date.now() - state.startTime) / 1000);
    
    const now = Date.now();
    state.shotsHistory = state.shotsHistory.filter(time => now - time < 1000);
    state.shotsPerSecond = state.shotsHistory.length;
    
    updateUI();
    saveState();
    
    if (state.score > state.highScore) {
        state.highScore = state.score;
        localStorage.setItem('space_defender_highscore', state.highScore);
    }
}

function updateBurgerMenu() {
    elements.burgerHighScore.textContent = formatNumber(state.highScore);
    
    const minutes = Math.floor(state.playTime / 60);
    const seconds = state.playTime % 60;
    elements.burgerPlayTime.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    
    elements.burgerShotsPerSecond.textContent = state.shotsPerSecond;
    
    const levelProgress = (state.score % 100) / 100 * 100;
    elements.burgerProgressBar.style.width = `${levelProgress}%`;
    elements.burgerProgressText.textContent = `${levelProgress.toFixed(0)}%`;
}

function endGame() {
    state.gameActive = false;
    cancelAnimationFrame(state.gameLoopId);
    clearInterval(state.asteroidIntervalId);
    clearInterval(state.statsIntervalId);
    
    elements.finalScore.textContent = formatNumber(state.score);
    elements.finalLevel.textContent = state.level;
    
    const minutes = Math.floor(state.playTime / 60);
    const seconds = state.playTime % 60;
    elements.finalTime.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    
    elements.gameOverScreen.classList.add('active');
    
    if (state.tokenValid && token && token.trim() !== '' && !state.resultsSent) {
        sendGameResults(state.score);
    }
}

async function sendGameResults(score) {
    if (state.resultsSent) return;
    
    try {
        const requestBody = {
            gameType: gameType,
            score: score
        };
        
        if (chatId) {
            requestBody.chatId = chatId;
        }
        
        const response = await fetch(`${CONFIG.API_BASE_URL}/api/v1/games/complete`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            body: JSON.stringify(requestBody)
        });
        
        if (response.ok) {
            state.resultsSent = true;
            localStorage.removeItem('pending_results_space');
            elements.savedScore.textContent = formatNumber(score);
            elements.completionModal.classList.add('active');
        } else {
            const errorText = await response.text();
            savePendingResults(score);
        }
    } catch (error) {
        savePendingResults(score);
    }
}

function savePendingResults(score) {
    const pendingResults = {
        score: score,
        level: state.level,
        playTime: state.playTime,
        timestamp: Date.now(),
        gameType: gameType,
        chatId: chatId
    };
    
    localStorage.setItem('pending_results_space', JSON.stringify(pendingResults));
}

async function sendPendingResults() {
    if (state.pendingScore > 0 && !state.resultsSent && state.tokenValid) {
        await sendGameResults(state.pendingScore);
        state.pendingScore = 0;
    }
}

function saveState() {
    const gameState = {
        score: state.score,
        lives: state.lives,
        level: state.level,
        playerPosition: state.playerPosition,
        highScore: state.highScore,
        timestamp: Date.now()
    };
    
    localStorage.setItem('space_defender_state', JSON.stringify(gameState));
}

function handleBeforeUnload(event) {
    if (!state.resultsSent && state.score > 0 && state.gameActive && state.tokenValid) {
        saveState();
        savePendingResults(state.score);
        
        const requestBody = {
            gameType: gameType,
            score: state.score
        };
        
        if (chatId) {
            requestBody.chatId = chatId;
        }
        
        const data = JSON.stringify(requestBody);
        const blob = new Blob([data], { type: 'application/json' });
        
        if (navigator.sendBeacon) {
            navigator.sendBeacon(`${CONFIG.API_BASE_URL}/api/v1/games/complete`, blob);
        }
        
        event.preventDefault();
        event.returnValue = `У вас есть несохраненные очки: ${formatNumber(state.score)}. Вы уверены, что хотите уйти?`;
        return event.returnValue;
    }
}

function handlePageHide() {
    if (!state.resultsSent && state.score > 0 && state.gameActive && state.tokenValid) {
        saveState();
        savePendingResults(state.score);
        
        const requestBody = {
            gameType: gameType,
            score: state.score
        };
        
        if (chatId) {
            requestBody.chatId = chatId;
        }
        
        const data = JSON.stringify(requestBody);
        const blob = new Blob([data], { type: 'application/json' });
        
        if (navigator.sendBeacon) {
            navigator.sendBeacon(`${CONFIG.API_BASE_URL}/api/v1/games/complete`, blob);
        }
    }
}

function handleVisibilityChange() {
    if (document.hidden) {
        saveState();
        if (!state.resultsSent && state.score > 0 && state.gameActive && state.tokenValid) {
            savePendingResults(state.score);
        }
    } else {
        setTimeout(sendPendingResults, 1000);
    }
}

function formatNumber(num) {
    if (num >= 1000000) {
        return (num / 1000000).toFixed(1).replace(/\.0$/, '') + 'M';
    }
    if (num >= 1000) {
        return (num / 1000).toFixed(1).replace(/\.0$/, '') + 'K';
    }
    return num.toString();
}

window.addEventListener('load', () => {
    for (let i = 0; i < 20; i++) {
        objectPool.asteroids.push(objectPool.getAsteroid());
        objectPool.projectiles.push(objectPool.getProjectile());
        objectPool.explosions.push(objectPool.getExplosion());
        objectPool.clickEffects.push(objectPool.getClickEffect());
    }
    
    initGame();
    
    if (window.innerWidth <= 768) {
        elements.leftBtn.style.display = 'flex';
        elements.fireBtn.style.display = 'flex';
        elements.rightBtn.style.display = 'flex';
    }
});

window.addEventListener('resize', () => {
    if (window.innerWidth <= 768) {
        elements.leftBtn.style.display = 'flex';
        elements.fireBtn.style.display = 'flex';
        elements.rightBtn.style.display = 'flex';
    } else {
        elements.leftBtn.style.display = 'none';
        elements.fireBtn.style.display = 'none';
        elements.rightBtn.style.display = 'none';
    }
    
    updateGameContainerRect();
});

document.addEventListener('touchstart', function(e) {
    if (e.touches.length > 1) {
        e.preventDefault();
    }
}, { passive: false });

let lastTouchEnd = 0;
document.addEventListener('touchend', function(e) {
    const now = Date.now();
    if (now - lastTouchEnd <= 300) {
        e.preventDefault();
    }
    lastTouchEnd = now;
}, false);