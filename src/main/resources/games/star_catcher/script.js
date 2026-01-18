const CONFIG = {
    API_BASE_URL: 'https://api.mnapp.ru',
    INITIAL_LIVES: 3,
    STAR_VALUE: 10,
    SPECIAL_STAR_VALUE: 50,
    COMBO_DURATION: 2000,
    LEVEL_UP_SCORE: 1000,
    MAX_STARS_PER_SECOND: 5,
    DIFFICULTY: {
        easy: {
            starSpeed: { min: 2, max: 4 },
            starSpawnRate: 1000,
            lives: 5
        },
        medium: {
            starSpeed: { min: 3, max: 6 },
            starSpawnRate: 800,
            lives: 3
        },
        hard: {
            starSpeed: { min: 4, max: 8 },
            starSpawnRate: 600,
            lives: 1
        }
    }
};

const params = new URLSearchParams(window.location.search);
const token = params.get('token');
const chatId = params.get('chatId');
const gameType = 'star-catcher';

let state = {
    score: 0,
    highScore: parseInt(localStorage.getItem('star_catcher_highscore')) || 0,
    lives: CONFIG.INITIAL_LIVES,
    level: 1,
    levelProgress: 0,
    gameActive: false,
    gamePaused: false,
    gameStarted: false,
    difficulty: 'medium',
    startTime: Date.now(),
    playTime: 0,
    lastStarCaught: null,
    combo: 0,
    comboMultiplier: 1,
    starsCaught: 0,
    starsMissed: 0,
    tokenValid: false,
    resultsSent: false,
    pendingScore: 0,
    stars: [],
    activeBoosters: {},
    starHistory: [],
    starsPerSecond: 0,
    burgerMenuOpen: false,
    gameLoop: null,
    starInterval: null,
    statsInterval: null
};

const elements = {
    gameContainer: document.querySelector('.game-container'),
    player: document.getElementById('player'),
    effectsContainer: document.getElementById('effects-container'),
    notificationsContainer: document.getElementById('notifications-container'),
    score: document.getElementById('score'),
    lives: document.getElementById('lives'),
    combo: document.getElementById('combo'),
    currentLevel: document.getElementById('current-level'),
    levelProgress: document.getElementById('level-progress'),
    burgerMenuBtn: document.getElementById('burger-menu-btn'),
    sideMenu: document.getElementById('side-menu'),
    menuClose: document.getElementById('menu-close'),
    menuResume: document.getElementById('menu-resume'),
    menuRestart: document.getElementById('menu-restart'),
    menuHighscore: document.getElementById('menu-highscore'),
    menuPlaytime: document.getElementById('menu-playtime'),
    menuStarsPerSec: document.getElementById('menu-stars-per-sec'),
    menuMultiplier: document.getElementById('menu-multiplier'),
    menuProgressText: document.getElementById('menu-progress-text'),
    menuProgressBar: document.getElementById('menu-progress-bar'),
    tokenStatus: document.getElementById('token-status'),
    boosterShield: document.getElementById('booster-shield'),
    boosterMagnet: document.getElementById('booster-magnet'),
    boosterMultiplier: document.getElementById('booster-multiplier'),
    startBtn: document.getElementById('start-btn'),
    pauseBtn: document.getElementById('pause-btn'),
    boostBtn: document.getElementById('boost-btn'),
    startGameBtn: document.getElementById('start-game-btn'),
    restartBtn: document.getElementById('restart-btn'),
    startModal: document.getElementById('start-modal'),
    gameOverModal: document.getElementById('game-over-modal'),
    finalScore: document.getElementById('final-score'),
    finalHighscore: document.getElementById('final-highscore'),
    finalTime: document.getElementById('final-time'),
    difficultyButtons: document.querySelectorAll('.difficulty-btn')
};

async function initGame() {
    loadSavedState();
    
    if (token && token.trim() !== '') {
        await validateToken();
    } else {
        showNotification('Демо-режим', 'Без сохранения результатов', 'warning');
        elements.tokenStatus.textContent = 'Демо-режим';
        elements.tokenStatus.style.color = '#f59e0b';
    }
    
    setupEventListeners();
    startStatsLoop();
    elements.startModal.classList.add('active');
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
            elements.tokenStatus.style.color = '#10b981';
        } else {
            throw new Error('Токен невалиден');
        }
    } catch (error) {
        state.tokenValid = false;
        elements.tokenStatus.textContent = 'Токен невалиден';
        elements.tokenStatus.style.color = '#ef4444';
    }
}

function loadSavedState() {
    const savedState = localStorage.getItem('star_catcher_state');
    if (savedState) {
        try {
            const parsed = JSON.parse(savedState);
            if (parsed.highScore) state.highScore = parsed.highScore;
            if (parsed.difficulty) state.difficulty = parsed.difficulty;
            
            elements.difficultyButtons.forEach(btn => {
                btn.classList.remove('active');
                if (btn.dataset.difficulty === state.difficulty) {
                    btn.classList.add('active');
                }
            });
            
            updateUI();
        } catch (e) {}
    }
    
    const pendingResults = localStorage.getItem('pending_star_results');
    if (pendingResults) {
        try {
            const results = JSON.parse(pendingResults);
            state.pendingScore = results.score || 0;
            if (state.pendingScore > 0) {
                setTimeout(sendPendingResults, 2000);
            }
        } catch (e) {}
    }
}

function setupEventListeners() {
    elements.gameContainer.addEventListener('touchmove', handleTouchMove, { passive: true });
    elements.gameContainer.addEventListener('mousemove', handleMouseMove);
    
    elements.startBtn.addEventListener('click', startGame);
    elements.pauseBtn.addEventListener('click', togglePause);
    elements.boostBtn.addEventListener('click', activateRandomBooster);
    elements.startGameBtn.addEventListener('click', startGameFromModal);
    elements.restartBtn.addEventListener('click', restartGame);
    
    elements.burgerMenuBtn.addEventListener('click', toggleBurgerMenu);
    elements.menuClose.addEventListener('click', toggleBurgerMenu);
    elements.menuResume.addEventListener('click', () => {
        toggleBurgerMenu();
        if (!state.gameActive) startGame();
    });
    elements.menuRestart.addEventListener('click', () => {
        toggleBurgerMenu();
        restartGame();
    });
    
    elements.difficultyButtons.forEach(btn => {
        btn.addEventListener('click', () => {
            elements.difficultyButtons.forEach(b => b.classList.remove('active'));
            btn.classList.add('active');
            state.difficulty = btn.dataset.difficulty;
            saveState();
        });
    });
    
    window.addEventListener('beforeunload', handleBeforeUnload);
    window.addEventListener('pagehide', handlePageHide);
    window.addEventListener('visibilitychange', handleVisibilityChange);
    
    document.addEventListener('touchstart', handleTouchStart, { passive: true });
}

function handleTouchMove(e) {
    if (!state.gameActive || state.gamePaused) return;
    
    const touch = e.touches[0];
    const rect = elements.gameContainer.getBoundingClientRect();
    const x = touch.clientX - rect.left;
    const playerX = (x / rect.width) * 100;
    
    updatePlayerPosition(playerX);
}

function handleMouseMove(e) {
    if (!state.gameActive || state.gamePaused) return;
    
    const rect = elements.gameContainer.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const playerX = (x / rect.width) * 100;
    
    updatePlayerPosition(playerX);
}

function handleTouchStart(e) {
    if (!state.gameActive || state.gamePaused) return;
    
    const touch = e.touches[0];
    const rect = elements.gameContainer.getBoundingClientRect();
    const x = touch.clientX - rect.left;
    const playerX = (x / rect.width) * 100;
    
    updatePlayerPosition(playerX);
}

function updatePlayerPosition(x) {
    x = Math.max(10, Math.min(90, x));
    elements.player.style.left = `${x}%`;
}

function startGame() {
    if (!state.gameStarted) {
        state.gameStarted = true;
        elements.startModal.classList.remove('active');
        state.lives = CONFIG.DIFFICULTY[state.difficulty].lives;
        updateUI();
    }
    
    state.gameActive = true;
    state.gamePaused = false;
    
    if (!state.gameLoop) {
        state.gameLoop = setInterval(gameLoop, 16);
    }
    
    if (!state.starInterval) {
        const spawnRate = CONFIG.DIFFICULTY[state.difficulty].starSpawnRate;
        state.starInterval = setInterval(createStar, spawnRate);
    }
}

function startGameFromModal() {
    startGame();
}

function gameLoop() {
    if (!state.gameActive || state.gamePaused) return;
    
    moveStars();
    updateBoosters();
    checkLevelUp();
}

function createStar() {
    if (!state.gameActive || state.gamePaused || state.stars.length > 15) return;
    
    const star = document.createElement('div');
    star.className = 'star';
    
    const starType = Math.random();
    if (starType < 0.1) {
        star.classList.add('special');
    } else if (starType < 0.3) {
        star.classList.add('bonus');
    }
    
    const left = Math.random() * 80 + 10;
    star.style.left = `${left}%`;
    
    const speedConfig = CONFIG.DIFFICULTY[state.difficulty].starSpeed;
    const speed = Math.random() * (speedConfig.max - speedConfig.min) + speedConfig.min;
    star.dataset.speed = speed;
    star.dataset.type = star.classList.contains('special') ? 'special' : 
                       star.classList.contains('bonus') ? 'bonus' : 'normal';
    
    elements.gameContainer.appendChild(star);
    state.stars.push(star);
    state.starHistory.push(Date.now());
}

function moveStars() {
    const containerHeight = elements.gameContainer.clientHeight;
    
    for (let i = state.stars.length - 1; i >= 0; i--) {
        const star = state.stars[i];
        const currentTop = parseFloat(star.style.top || 0);
        const speed = parseFloat(star.dataset.speed);
        const newTop = currentTop + speed;
        
    star.style.top = `${newTop}px`;
    
    if (newTop > containerHeight * 0.75) {
        const playerRect = elements.player.getBoundingClientRect();
        const starRect = star.getBoundingClientRect();
        
        const magnetActive = state.activeBoosters.magnet;
        const magnetRadius = magnetActive ? 50 : 0;
        
        const playerCenterX = playerRect.left + playerRect.width / 2;
        const playerCenterY = playerRect.top + playerRect.height / 2;
        const starCenterX = starRect.left + starRect.width / 2;
        const starCenterY = starRect.top + starRect.height / 2;
        
        const distance = Math.sqrt(
            Math.pow(starCenterX - playerCenterX, 2) +
            Math.pow(starCenterY - playerCenterY, 2)
        );
        
        if (distance < (playerRect.width / 2 + starRect.width / 2 + magnetRadius)) {
            catchStar(star, star.dataset.type);
            state.stars.splice(i, 1);
            star.remove();
            continue;
        }
    }
    
    if (newTop > containerHeight) {
        missStar(star, star.dataset.type);
        state.stars.splice(i, 1);
        star.remove();
    }
    }
}

function catchStar(star, type) {
    const now = Date.now();
    let value = CONFIG.STAR_VALUE;
    
    if (type === 'special') value = CONFIG.SPECIAL_STAR_VALUE;
    if (type === 'bonus') value = CONFIG.STAR_VALUE * 2;
    
    if (state.lastStarCaught && now - state.lastStarCaught < CONFIG.COMBO_DURATION) {
        state.combo++;
        state.comboMultiplier = 1 + (state.combo * 0.1);
    } else {
        state.combo = 1;
        state.comboMultiplier = 1;
    }
    
    state.lastStarCaught = now;
    value = Math.floor(value * state.comboMultiplier);
    
    if (state.activeBoosters.multiplier) {
        value *= 2;
    }
    
    state.score += value;
    state.starsCaught++;
    state.levelProgress += value;
    
    const rect = star.getBoundingClientRect();
    createEffect(rect, `+${value}`, type === 'special' ? 'var(--neon-pink)' : 
                type === 'bonus' ? 'var(--neon-green)' : 'var(--neon-blue)');
    
    elements.player.style.transform = 'scale(1.2)';
    setTimeout(() => {
        elements.player.style.transform = 'scale(1)';
    }, 200);
    
    updateUI();
    checkAchievements();
}

function missStar(star, type) {
    state.starsMissed++;
    
    if (!state.activeBoosters.shield) {
        state.lives--;
        
        elements.gameContainer.style.backgroundColor = 'rgba(239, 68, 68, 0.3)';
        setTimeout(() => {
            elements.gameContainer.style.backgroundColor = '';
        }, 200);
        
        if (state.lives <= 0) {
            endGame();
        }
    }
    
    state.combo = 0;
    state.comboMultiplier = 1;
    
    updateUI();
}

function createEffect(rect, text, color) {
    const effect = document.createElement('div');
    effect.className = 'click-effect';
    effect.textContent = text;
    effect.style.left = `${rect.left + rect.width / 2}px`;
    effect.style.top = `${rect.top}px`;
    effect.style.color = color;
    
    elements.effectsContainer.appendChild(effect);
    
    setTimeout(() => {
        effect.remove();
    }, 1000);
}

function activateRandomBooster() {
    if (!state.gameActive || state.gamePaused) return;
    
    const boosters = ['shield', 'magnet', 'multiplier'];
    const randomBooster = boosters[Math.floor(Math.random() * boosters.length)];
    
    activateBooster(randomBooster);
}

function activateBooster(type) {
    state.activeBoosters[type] = Date.now();
    
    const boosterElement = elements[`booster${type.charAt(0).toUpperCase() + type.slice(1)}`];
    boosterElement.dataset.active = "true";
    
    const timer = boosterElement.querySelector('.booster-timer');
    timer.style.transition = 'transform 10s linear';
    timer.style.transform = 'scaleX(0)';
    
    const boosterNames = {
        shield: 'Щит',
        magnet: 'Магнит',
        multiplier: 'Множитель x2'
    };
    showNotification('Бустер активирован!', boosterNames[type], 'success');
    
    setTimeout(() => {
        deactivateBooster(type);
    }, 10000);
}

function deactivateBooster(type) {
    delete state.activeBoosters[type];
    
    const boosterElement = elements[`booster${type.charAt(0).toUpperCase() + type.slice(1)}`];
    if (boosterElement) {
        boosterElement.dataset.active = "false";
        const timer = boosterElement.querySelector('.booster-timer');
        timer.style.transition = 'none';
        timer.style.transform = 'scaleX(1)';
    }
}

function updateBoosters() {
    const now = Date.now();
    Object.keys(state.activeBoosters).forEach(type => {
        const startTime = state.activeBoosters[type];
        if (now - startTime > 10000) {
            deactivateBooster(type);
        }
    });
}

function checkLevelUp() {
    const levelUpScore = CONFIG.LEVEL_UP_SCORE * state.level;
    
    if (state.levelProgress >= levelUpScore) {
        state.level++;
        state.levelProgress = state.levelProgress - levelUpScore;
        
        showNotification('Уровень повышен!', `Теперь вы на ${state.level} уровне`, 'success');
        createLevelUpEffect();
        
        increaseDifficulty();
    }
    
    const progressPercent = (state.levelProgress / (CONFIG.LEVEL_UP_SCORE * state.level)) * 100;
    elements.levelProgress.style.width = `${progressPercent}%`;
    elements.menuProgressBar.style.width = `${progressPercent}%`;
    elements.menuProgressText.textContent = `${Math.round(progressPercent)}%`;
}

function increaseDifficulty() {
    if (state.starInterval) {
        clearInterval(state.starInterval);
        const baseRate = CONFIG.DIFFICULTY[state.difficulty].starSpawnRate;
        const newRate = Math.max(200, baseRate - (state.level * 50));
        state.starInterval = setInterval(createStar, newRate);
    }
}

function createLevelUpEffect() {
    for (let i = 0; i < 5; i++) {
        setTimeout(() => {
            const x = Math.random() * window.innerWidth;
            const y = Math.random() * window.innerHeight;
            createEffect({ left: x, top: y, width: 0, height: 0 }, '⭐', 'var(--neon-green)');
        }, i * 100);
    }
}

function checkAchievements() {
    const achievements = [
        { score: 1000, title: 'Новичок' },
        { score: 5000, title: 'Опытный ловец' },
        { score: 10000, title: 'Мастер звезд' }
    ];
    
    achievements.forEach(achievement => {
        if (state.score >= achievement.score && state.score - 100 < achievement.score) {
            showNotification('Достижение!', achievement.title, 'success');
        }
    });
}

function endGame() {
    state.gameActive = false;
    state.gameStarted = false;
    
    clearInterval(state.gameLoop);
    clearInterval(state.starInterval);
    state.gameLoop = null;
    state.starInterval = null;
    
    state.stars.forEach(star => star.remove());
    state.stars = [];
    
    if (state.score > state.highScore) {
        state.highScore = state.score;
        localStorage.setItem('star_catcher_highscore', state.highScore);
        showNotification('Новый рекорд!', `Поздравляем: ${formatNumber(state.score)}`, 'success');
    }
    
    elements.finalScore.textContent = formatNumber(state.score);
    elements.finalHighscore.textContent = formatNumber(state.highScore);
    elements.finalTime.textContent = formatTime(state.playTime);
    
    setTimeout(() => {
        elements.gameOverModal.classList.add('active');
    }, 500);
    
    if (state.tokenValid) {
        sendGameResults();
    }
}

function restartGame() {
    state.score = 0;
    state.lives = CONFIG.DIFFICULTY[state.difficulty].lives;
    state.level = 1;
    state.levelProgress = 0;
    state.combo = 0;
    state.comboMultiplier = 1;
    state.starsCaught = 0;
    state.starsMissed = 0;
    state.startTime = Date.now();
    state.playTime = 0;
    
    Object.keys(state.activeBoosters).forEach(type => deactivateBooster(type));
    state.activeBoosters = {};
    
    elements.gameOverModal.classList.remove('active');
    elements.startModal.classList.remove('active');
    
    updateUI();
    
    setTimeout(startGame, 300);
}

function togglePause() {
    if (!state.gameActive) return;
    
    state.gamePaused = !state.gamePaused;
    
    if (state.gamePaused) {
        showNotification('Игра на паузе', 'Нажмите кнопку для продолжения', 'warning');
    }
}

function toggleBurgerMenu() {
    state.burgerMenuOpen = !state.burgerMenuOpen;
    
    if (state.burgerMenuOpen) {
        elements.sideMenu.classList.add('active');
        updateMenuStats();
    } else {
        elements.sideMenu.classList.remove('active');
    }
}

function updateUI() {
    elements.score.textContent = formatNumber(state.score);
    elements.lives.textContent = state.lives;
    elements.combo.textContent = state.combo;
    elements.currentLevel.textContent = state.level;
    
    const progressPercent = (state.levelProgress / (CONFIG.LEVEL_UP_SCORE * state.level)) * 100;
    elements.levelProgress.style.width = `${progressPercent}%`;
}

function updateMenuStats() {
    elements.menuHighscore.textContent = formatNumber(state.highScore);
    elements.menuPlaytime.textContent = formatTime(state.playTime);
    elements.menuStarsPerSec.textContent = state.starsPerSecond.toFixed(1);
    elements.menuMultiplier.textContent = `${state.comboMultiplier.toFixed(1)}x`;
    
    const progressPercent = (state.levelProgress / (CONFIG.LEVEL_UP_SCORE * state.level)) * 100;
    elements.menuProgressBar.style.width = `${progressPercent}%`;
    elements.menuProgressText.textContent = `${Math.round(progressPercent)}%`;
}

function startStatsLoop() {
    state.statsInterval = setInterval(() => {
        state.playTime = Math.floor((Date.now() - state.startTime) / 1000);
        
        const now = Date.now();
        state.starHistory = state.starHistory.filter(time => now - time < 1000);
        state.starsPerSecond = state.starHistory.length;
        
        if (state.burgerMenuOpen) {
            updateMenuStats();
        }
        
        saveState();
    }, 1000);
}

function showNotification(title, message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification ${type}`;
    
    const icons = {
        success: 'fas fa-check-circle',
        warning: 'fas fa-exclamation-triangle',
        error: 'fas fa-times-circle',
        info: 'fas fa-info-circle'
    };
    
    notification.innerHTML = `
        <i class="${icons[type]}"></i>
        <div class="notification-content">
            <div class="notification-title">${title}</div>
            <div class="notification-message">${message}</div>
        </div>
    `;
    
    elements.notificationsContainer.appendChild(notification);
    
    setTimeout(() => {
        notification.style.opacity = '0';
        setTimeout(() => notification.remove(), 300);
    }, 2000);
}

function saveState() {
    const gameState = {
        highScore: state.highScore,
        difficulty: state.difficulty,
        timestamp: Date.now()
    };
    localStorage.setItem('star_catcher_state', JSON.stringify(gameState));
}

async function sendGameResults() {
    if (state.resultsSent || !state.tokenValid || !state.gameActive) return;
    
    try {
        const requestBody = {
            gameType: gameType,
            score: state.score
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
            localStorage.removeItem('pending_star_results');
        } else {
            const errorText = await response.text();
            savePendingResults();
        }
    } catch (error) {
        savePendingResults();
    }
}

async function sendPendingResults() {
    if (state.pendingScore > 0 && !state.resultsSent && state.tokenValid) {
        await sendGameResults();
        state.pendingScore = 0;
    }
}

function savePendingResults() {
    const pendingResults = {
        score: state.score,
        timestamp: Date.now(),
        gameType: gameType,
        chatId: chatId
    };
    localStorage.setItem('pending_star_results', JSON.stringify(pendingResults));
}

function handleBeforeUnload(event) {
    if (!state.resultsSent && state.score > 0 && state.gameActive && state.tokenValid) {
        saveState();
        savePendingResults();
        
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
        event.returnValue = `Несохраненные очки: ${formatNumber(state.score)}. Вы уверены, что хотите уйти?`;
        return event.returnValue;
    }
}

function handlePageHide() {
    if (!state.resultsSent && state.score > 0 && state.gameActive && state.tokenValid) {
        saveState();
        savePendingResults();
        
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
            savePendingResults();
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

function formatTime(seconds) {
    const minutes = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
}

document.addEventListener('DOMContentLoaded', initGame);

window.addEventListener('beforeunload', () => {
    if (state.gameLoop) clearInterval(state.gameLoop);
    if (state.starInterval) clearInterval(state.starInterval);
    if (state.statsInterval) clearInterval(state.statsInterval);
});