const CONFIG = {
    GOAL_CLICKS: 10000000,
    CLICK_VALUE: 1,
    API_BASE_URL: 'https://api.mnapp.ru'
};

// Инициализация состояния
const params = new URLSearchParams(window.location.search);
const token = params.get('token');
const chatId = params.get('chatId');
const gameType = 'clicker';

let state = {
    score: 0,
    totalClicks: 0,
    highScore: parseInt(localStorage.getItem('clicker_highscore')) || 0,
    playTime: 0,
    startTime: Date.now(),
    lastClickTime: Date.now(),
    clicksPerSecond: 0,
    clickHistory: [],
    resultsSent: false,
    pendingScore: 0,
    gameActive: false,
    lastClickTimestamp: Date.now(),
    cpsUpdateInterval: null,
    burgerMenuOpen: false,
    tokenValid: false
};

// Получаем элементы DOM
const elements = {
    score: document.getElementById('score'),
    totalClicks: document.getElementById('total-clicks'),
    progressBar: document.getElementById('progress-bar'),
    progressText: document.getElementById('progress-text'),
    goalText: document.getElementById('goal-text'),
    clickArea: document.getElementById('click-area'),
    effectsContainer: document.getElementById('effects-container'),
    cps: document.getElementById('cps'),
    playTime: document.getElementById('play-time'),
    highScore: document.getElementById('high-score'),
    completionModal: document.getElementById('completion-modal'),
    finalScore: document.getElementById('final-score'),
    continueBtn: document.getElementById('continue-btn'),
    tokenStatus: document.getElementById('token-status'),
    burgerMenuBtn: document.getElementById('burger-menu-btn'),
    burgerMenu: document.getElementById('burger-menu'),
    burgerMenuClose: document.getElementById('burger-menu-close'),
    burgerCps: document.getElementById('burger-cps'),
    burgerPlayTime: document.getElementById('burger-play-time'),
    burgerHighScore: document.getElementById('burger-high-score'),
    burgerProgressBar: document.getElementById('burger-progress-bar'),
    burgerProgressText: document.getElementById('burger-progress-text'),
    burgerGoalText: document.getElementById('burger-goal-text')
};

async function initGame() {
    if (!token || token.trim() === '') {
        elements.tokenStatus.textContent = 'Демо-режим';
        elements.tokenStatus.style.color = '#ff2d75';
        state.gameActive = false;
        setTimeout(() => {
            alert('Для сохранения результатов требуется токен авторизации.\n\nДобавьте параметр ?token=your_token в URL\n\nСейчас игра работает в демо-режиме');
        }, 1000);
        initDemoMode();
        return;
    }

    await validateToken();
    loadSavedState();
    elements.goalText.textContent = formatNumber(CONFIG.GOAL_CLICKS);
    elements.burgerGoalText.textContent = formatNumberShort(CONFIG.GOAL_CLICKS);
    setupEventListeners();
    startGameLoops();
    state.gameActive = true;
    updateBurgerMenu();
}

function initDemoMode() {
    loadSavedState();
    elements.goalText.textContent = formatNumber(CONFIG.GOAL_CLICKS);
    elements.burgerGoalText.textContent = formatNumberShort(CONFIG.GOAL_CLICKS);
    setupDemoEventListeners();
    startGameLoops();
    updateUI();
    updateBurgerMenu();
}

async function validateToken() {
    if (!token) return;

    try {
        const response = await fetch(`${CONFIG.API_BASE_URL}/api/v1/auth/token/validate-token`, {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}`,
                'Content-Type': 'application/json'
            }
            // Убрали credentials: 'include'
        });

        if (response.ok) {
            state.tokenValid = true;
            elements.tokenStatus.textContent = 'Токен валиден';
            elements.tokenStatus.style.color = '#00ff88';
            console.log('Токен успешно валидирован');
        } else {
            const errorText = await response.text();
            throw new Error(`Ошибка валидации токена: ${response.status} ${errorText}`);
        }
    } catch (error) {
        console.error('Ошибка при валидации токена:', error);
        state.tokenValid = false;
        elements.tokenStatus.textContent = 'Токен невалиден';
        elements.tokenStatus.style.color = '#ffd700';

        setTimeout(() => {
            alert(`Ошибка при проверке токена: ${error.message}\n\nИгра будет работать в демо-режиме. Результаты не будут сохранены.`);
        }, 1000);
    }
}


function loadSavedState() {
    const savedState = localStorage.getItem('clicker_state');
    if (savedState) {
        try {
            const parsed = JSON.parse(savedState);
            if (parsed.score) state.score = parsed.score;
            if (parsed.totalClicks) state.totalClicks = parsed.totalClicks;
            if (parsed.highScore) state.highScore = parsed.highScore;
            console.log('Состояние игры загружено из localStorage');
        } catch (e) {
            console.error('Ошибка при загрузке состояния:', e);
        }
    }

    const pendingResults = localStorage.getItem('pending_results');
    if (pendingResults) {
        try {
            const results = JSON.parse(pendingResults);
            state.pendingScore = results.score || 0;
            if (state.pendingScore > 0) {
                console.log('Найдены неотправленные результаты:', state.pendingScore);
                setTimeout(sendPendingResults, 2000);
            }
        } catch (e) {
            console.error('Ошибка при загрузке неотправленных результатов:', e);
        }
    }

    updateUI();
    updateBurgerMenu();
}

function setupEventListeners() {
    elements.clickArea.addEventListener('click', handleClick);
    elements.clickArea.addEventListener('touchstart', handleTouch, { passive: true });
    elements.continueBtn.addEventListener('click', () => {
        elements.completionModal.classList.remove('active');
    });
    elements.burgerMenuBtn.addEventListener('click', toggleBurgerMenu);
    elements.burgerMenuClose.addEventListener('click', toggleBurgerMenu);
    elements.burgerMenu.addEventListener('click', (e) => {
        if (e.target === elements.burgerMenu) {
            toggleBurgerMenu();
        }
    });
    window.addEventListener('beforeunload', handleBeforeUnload);
    window.addEventListener('pagehide', handlePageHide);
    window.addEventListener('visibilitychange', handleVisibilityChange);
    document.addEventListener('visibilitychange', () => {
        if (document.hidden) {
            saveState();
        }
    });
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && state.burgerMenuOpen) {
            toggleBurgerMenu();
        }
    });
}

function setupDemoEventListeners() {
    elements.clickArea.addEventListener('click', handleDemoClick);
    elements.clickArea.addEventListener('touchstart', handleDemoTouch, { passive: true });
    elements.burgerMenuBtn.addEventListener('click', toggleBurgerMenu);
    elements.burgerMenuClose.addEventListener('click', toggleBurgerMenu);
    elements.burgerMenu.addEventListener('click', (e) => {
        if (e.target === elements.burgerMenu) {
            toggleBurgerMenu();
        }
    });
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && state.burgerMenuOpen) {
            toggleBurgerMenu();
        }
    });
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

function startGameLoops() {
    setInterval(() => {
        updateStats();
        saveState();
    }, 1000);

    setInterval(updatePlayTime, 1000);
    state.cpsUpdateInterval = setInterval(updateCPS, 1000);
}

function updateStats() {
    const now = Date.now();
    state.clickHistory = state.clickHistory.filter(time => now - time < 1000);
    if (state.score > state.highScore) {
        state.highScore = state.score;
        localStorage.setItem('clicker_highscore', state.highScore);
    }
}

function updateCPS() {
    const now = Date.now();
    state.clickHistory = state.clickHistory.filter(time => now - time < 1000);
    state.clicksPerSecond = state.clickHistory.length;
    elements.cps.textContent = state.clicksPerSecond;
    elements.burgerCps.textContent = state.clicksPerSecond;
}

function updatePlayTime() {
    state.playTime = Math.floor((Date.now() - state.startTime) / 1000);
    const minutes = Math.floor(state.playTime / 60);
    const seconds = state.playTime % 60;
    const timeString = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
    elements.playTime.textContent = timeString;
    elements.burgerPlayTime.textContent = timeString;
}

function handleClick(event) {
    if (!state.gameActive) return;
    const rect = elements.clickArea.getBoundingClientRect();
    const x = event.clientX - rect.left;
    const y = event.clientY - rect.top;
    performClick(x, y);
}

function handleTouch(event) {
    if (!state.gameActive) return;
    event.preventDefault();
    const touch = event.touches[0];
    const rect = elements.clickArea.getBoundingClientRect();
    const x = touch.clientX - rect.left;
    const y = touch.clientY - rect.top;
    performClick(x, y);
}

function handleDemoClick(event) {
    const rect = elements.clickArea.getBoundingClientRect();
    const x = event.clientX - rect.left;
    const y = event.clientY - rect.top;
    performDemoClick(x, y);
}

function handleDemoTouch(event) {
    event.preventDefault();
    const touch = event.touches[0];
    const rect = elements.clickArea.getBoundingClientRect();
    const x = touch.clientX - rect.left;
    const y = touch.clientY - rect.top;
    performDemoClick(x, y);
}

function performClick(x, y) {
    const now = Date.now();
    state.lastClickTime = now;
    state.clickHistory.push(now);
    state.score += CONFIG.CLICK_VALUE;
    state.totalClicks += 1;
    createClickEffect(x, y, `+${CONFIG.CLICK_VALUE}`);
    checkAchievements();
    checkGameCompletion();
    updateUI();
    updateBurgerMenu();
}

function performDemoClick(x, y) {
    const now = Date.now();
    state.lastClickTime = now;
    state.clickHistory.push(now);
    state.score += CONFIG.CLICK_VALUE;
    state.totalClicks += 1;
    createClickEffect(x, y, `+${CONFIG.CLICK_VALUE} (демо)`);
    checkAchievements();
    if (state.totalClicks >= CONFIG.GOAL_CLICKS && !state.resultsSent) {
        elements.finalScore.textContent = formatNumber(state.score);
        elements.completionModal.classList.add('active');
        createCelebrationEffects();
    }
    updateUI();
    updateBurgerMenu();
}

function updateUI() {
    elements.score.textContent = formatNumber(state.score);
    elements.totalClicks.textContent = formatNumber(state.totalClicks);
    elements.highScore.textContent = formatNumber(state.highScore);

    const progress = Math.min(100, (state.totalClicks / CONFIG.GOAL_CLICKS) * 100);
    elements.progressBar.style.width = `${progress}%`;
    elements.progressText.textContent = `${progress.toFixed(2)}%`;
}

function updateBurgerMenu() {
    elements.burgerHighScore.textContent = formatNumber(state.highScore);

    const progress = Math.min(100, (state.totalClicks / CONFIG.GOAL_CLICKS) * 100);
    elements.burgerProgressBar.style.width = `${progress}%`;
    elements.burgerProgressText.textContent = `${progress.toFixed(2)}%`;
}

function checkAchievements() {
    const achievements = [
        { threshold: 100, title: 'Новичок', message: '100 кликов!' },
        { threshold: 1000, title: 'Опытный', message: '1000 кликов!' },
        { threshold: 10000, title: 'Мастер', message: '10,000 кликов!' },
        { threshold: 100000, title: 'Легенда', message: '100,000 кликов!' },
        { threshold: 500000, title: 'Бог кликов', message: '500,000 кликов!' }
    ];
    achievements.forEach(achievement => {
        if (state.totalClicks === achievement.threshold) {
            createSpecialEffect('🏆');
        }
    });
}

function checkGameCompletion() {
    if (state.totalClicks >= CONFIG.GOAL_CLICKS && !state.resultsSent && state.gameActive) {
        elements.finalScore.textContent = formatNumber(state.score);
        elements.completionModal.classList.add('active');
        createCelebrationEffects();
        sendGameResults(state.score);
    }
}

function createCelebrationEffects() {
    for (let i = 0; i < 20; i++) {
        setTimeout(() => {
            const emojis = ['🎉', '🎊', '🏆', '⭐', '✨', '👑', '💎'];
            const emoji = emojis[Math.floor(Math.random() * emojis.length)];
            createSpecialEffect(emoji);
        }, i * 100);
    }
}

async function sendGameResults(score) {
    if (state.resultsSent || !state.gameActive || !state.tokenValid || !token) {
        console.log('Результаты не отправляются:', {
            resultsSent: state.resultsSent,
            gameActive: state.gameActive,
            tokenValid: state.tokenValid,
            hasToken: !!token
        });
        return;
    }

    try {
        const requestBody = {
            gameType: gameType,
            score: score
        };

        // Добавляем chatId только если он есть и является валидным UUID
        if (chatId && chatId.trim() !== '' && isValidUUID(chatId)) {
            requestBody.chatId = chatId;
        }

        console.log('Отправка результатов игры:', requestBody);

        const response = await fetch(`${CONFIG.API_BASE_URL}/api/v1/games/complete`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            // Убрали credentials: 'include'
            body: JSON.stringify(requestBody)
        });

        console.log('Ответ сервера:', response.status, response.statusText);

        if (response.ok) {
            try {
                const result = await response.json();
                console.log('Результаты успешно отправлены:', result);
            } catch (e) {
                console.log('Результаты успешно отправлены (ответ не JSON)');
            }

            state.resultsSent = true;
            localStorage.removeItem('pending_results');

            setTimeout(() => {
                alert('Результаты успешно сохранены! Очки зачислены на ваш аккаунт.');
            }, 500);
        } else {
            let errorText = '';
            try {
                errorText = await response.text();
            } catch (e) {
                errorText = 'Не удалось прочитать текст ошибки';
            }
            console.error('Ошибка при отправке результатов:', response.status, errorText);
            savePendingResults(score);

            setTimeout(() => {
                alert(`Ошибка при сохранении результатов (${response.status}). Результаты будут сохранены локально и отправлены позже.`);
            }, 500);
        }
    } catch (error) {
        console.error('Сетевая ошибка при отправке результатов:', error);
        savePendingResults(score);

        setTimeout(() => {
            alert('Сетевая ошибка. Результаты будут сохранены локально и отправлены позже.');
        }, 500);
    }
}

// Функция для проверки UUID
function isValidUUID(uuid) {
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    return uuidRegex.test(uuid);
}

async function sendPendingResults() {
    if (state.pendingScore > 0 && !state.resultsSent && state.tokenValid && token) {
        console.log('Попытка отправить неотправленные результаты:', state.pendingScore);
        await sendGameResults(state.pendingScore);
        state.pendingScore = 0;
    }
}

function savePendingResults(score) {
    const pendingResults = {
        score: score,
        timestamp: Date.now(),
        gameType: gameType,
        chatId: chatId || null
    };
    localStorage.setItem('pending_results', JSON.stringify(pendingResults));
    console.log('Результаты сохранены для последующей отправки:', pendingResults);
}

function handleBeforeUnload(event) {
    if (!state.resultsSent && state.score > 0 && state.gameActive && state.tokenValid && token) {
        saveState();
        savePendingResults(state.score);

        // Просто сохраняем в localStorage, без попытки отправки через Beacon
        event.preventDefault();
        event.returnValue = `У вас есть несохраненные очки: ${formatNumber(state.score)}. Вы уверены, что хотите уйти?`;
        return event.returnValue;
    }
}

function handlePageHide() {
    if (!state.resultsSent && state.score > 0 && state.gameActive && state.tokenValid && token) {
        saveState();
        savePendingResults(state.score);
        // Просто сохраняем в localStorage
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

function saveState() {
    const gameState = {
        score: state.score,
        totalClicks: state.totalClicks,
        highScore: state.highScore,
        timestamp: Date.now()
    };
    localStorage.setItem('clicker_state', JSON.stringify(gameState));
}

function createClickEffect(x, y, text) {
    const effect = document.createElement('div');
    effect.className = 'click-effect';
    effect.textContent = text;
    effect.style.left = `${x}px`;
    effect.style.top = `${y}px`;
    const colors = ['#00d4ff', '#9d4edd', '#ff2d75', '#00ff88', '#ffd700'];
    const color = colors[Math.floor(Math.random() * colors.length)];
    effect.style.color = color;
    elements.effectsContainer.appendChild(effect);
    setTimeout(() => {
        effect.remove();
    }, 1000);
}

function createSpecialEffect(emoji) {
    const rect = elements.clickArea.getBoundingClientRect();
    const x = rect.width / 2 + (Math.random() - 0.5) * 200;
    const y = rect.height / 2 + (Math.random() - 0.5) * 200;
    const effect = document.createElement('div');
    effect.className = 'click-effect';
    effect.textContent = emoji;
    effect.style.fontSize = '2.5rem';
    effect.style.left = `${x}px`;
    effect.style.top = `${y}px`;
    elements.effectsContainer.appendChild(effect);
    setTimeout(() => {
        effect.remove();
    }, 1500);
}

function formatNumber(num) {
    if (num >= 1000000) {
        return (num / 1000000).toFixed(1).replace(/\.0$/, '') + 'M';
    }
    if (num >= 1000) {
        return (num / 1000).toFixed(1).replace(/\.0$/, '') + 'K';
    }
    return num.toLocaleString('ru-RU');
}

function formatNumberShort(num) {
    if (num >= 1000000) {
        return (num / 1000000).toFixed(0) + 'M';
    }
    if (num >= 1000) {
        return (num / 1000).toFixed(0) + 'K';
    }
    return num.toString();
}

function clearIntervals() {
    if (state.cpsUpdateInterval) {
        clearInterval(state.cpsUpdateInterval);
    }
}

// Инициализация игры
document.addEventListener('DOMContentLoaded', initGame);
window.addEventListener('beforeunload', clearIntervals);