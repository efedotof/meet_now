// Получаем параметры из URL
const params = new URLSearchParams(window.location.search);
const token = params.get('token');
const chatId = params.get('chatId');
const gameType = 'clicker';

// Конфигурация игры
const GOAL_CLICKS = 10000000; // 10 миллионов кликов
const CLICK_VALUE = 1; // 1 очко за клик

let score = 0;
let totalClicks = 0;
let resultsSent = false;

// Проверка наличия обязательных параметров
if (!token) {
    alert("Missing token in URL. Example:\n?token=your_token\nor\n?token=your_token&chatId=456");
    throw new Error("Missing token");
}

// Конфигурация API
const API_BASE_URL = 'https://mnapp.ru';

// Элементы игры
const clickArea = document.getElementById('click-area');
const scoreElement = document.getElementById('score');
const totalClicksElement = document.getElementById('total-clicks');
const effectsContainer = document.getElementById('effects-container');
const progressBar = document.getElementById('progress-bar');
const goalText = document.getElementById('goal-text');

// Устанавливаем цель в тексте
goalText.textContent = formatLargeNumber(GOAL_CLICKS);

// Функция для отправки результатов
async function sendGameResults(finalScore) {
    if (resultsSent) return;

    try {
        const requestBody = {
            gameType: gameType,
            score: finalScore
        };

        // Добавляем chatId только если он есть
        if (chatId) {
            requestBody.chatId = chatId;
        }

        console.log('Sending game results:', requestBody);
        console.log('Token:', token ? 'present' : 'missing');

        const response = await fetch(`${API_BASE_URL}/api/v1/games/complete`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${token}`
            },
            body: JSON.stringify(requestBody)
        });

        console.log('Response status:', response.status);

        if (response.ok) {
            console.log("Score sent successfully!");
            resultsSent = true;

            // Показываем сообщение об успехе
            if (chatId) {
                alert(`Поздравляем! Вы достигли цели в ${formatLargeNumber(GOAL_CLICKS)} кликов!\nРезультаты отправлены в чат! Начислено очков: ${formatLargeNumber(finalScore)}`);
            } else {
                alert(`Поздравляем! Вы достигли цели в ${formatLargeNumber(GOAL_CLICKS)} кликов!\nРезультаты сохранены! Начислено очков: ${formatLargeNumber(finalScore)}`);
            }
        } else {
            const errorText = await response.text();
            console.error("Failed to send score:", response.status, errorText);
            alert(`Ошибка при отправке результатов: ${response.status} - ${errorText}`);
        }
    } catch (error) {
        console.error("Error sending score:", error);
        alert("Ошибка сети при отправке результатов: " + error.message);
    }
}

// Функция для проверки достижения цели
function checkGameCompletion() {
    if (totalClicks >= GOAL_CLICKS && !resultsSent) {
        console.log('Game completed! Total clicks:', totalClicks, 'Score:', score);

        // Создаем эффект завершения игры
        createEffect('🎉 УСПЕХ! 🎉', clickArea);

        // Создаем дополнительные эффекты для празднования
        for (let i = 0; i < 10; i++) {
            setTimeout(() => {
                createEffect('⭐', clickArea);
                createEffect('🏆', clickArea);
            }, i * 200);
        }

        setTimeout(() => {
            sendGameResults(score);
        }, 2000);
    }
}

// Создание эффекта текста
function createEffect(text, parent) {
    const effect = document.createElement('div');
    effect.className = 'effect';
    effect.textContent = text;

    const rect = parent.getBoundingClientRect();
    const x = rect.left + rect.width / 2;
    const y = rect.top + rect.height / 2;

    effect.style.left = `${x}px`;
    effect.style.top = `${y}px`;

    effectsContainer.appendChild(effect);

    setTimeout(() => {
        effect.remove();
    }, 1000);
}

// Обработка клика
function handleClick() {
    score += CLICK_VALUE;
    totalClicks++;

    // Создаем эффект только иногда, чтобы не перегружать устройство
    if (totalClicks % 100 === 0) {
        createEffect(`+${CLICK_VALUE}`, clickArea);
    }

    // Создаем дополнительный эффект каждые 1000 кликов
    if (totalClicks % 1000 === 0) {
        createEffect(`🔥 ${formatLargeNumber(totalClicks)}`, clickArea);
    }

    // Создаем особый эффект каждые 1% прогресса
    const progressPercent = Math.floor((totalClicks / GOAL_CLICKS) * 100);
    if (totalClicks % Math.floor(GOAL_CLICKS / 100) === 0 && progressPercent > 0) {
        createEffect(`🎯 ${progressPercent}%`, clickArea);
    }

    // Создаем особый эффект на половине пути
    if (totalClicks === Math.floor(GOAL_CLICKS / 2)) {
        createEffect('🥈 Полпути!', clickArea);
    }

    // Создаем особый эффект на 75%
    if (totalClicks === Math.floor(GOAL_CLICKS * 0.75)) {
        createEffect('🥈 75%!', clickArea);
    }

    // Создаем особый эффект на 90%
    if (totalClicks === Math.floor(GOAL_CLICKS * 0.9)) {
        createEffect('👑 Почти у цели!', clickArea);
    }

    updateUI();
    checkGameCompletion();
}

// Обновление интерфейса
function updateUI() {
    scoreElement.textContent = formatLargeNumber(score);
    totalClicksElement.textContent = formatLargeNumber(totalClicks);

    // Прогресс-бар показывает прогресс к цели
    const progress = Math.min(100, (totalClicks / GOAL_CLICKS) * 100);
    progressBar.style.width = `${progress}%`;

    // Меняем цвет прогресс-бара в зависимости от прогресса
    if (progress >= 100) {
        progressBar.style.background = 'linear-gradient(90deg, var(--success-color), #00ff88)';
    } else if (progress >= 75) {
        progressBar.style.background = 'linear-gradient(90deg, #ffd700, #ffed4e)';
    } else if (progress >= 50) {
        progressBar.style.background = 'linear-gradient(90deg, var(--primary-color), var(--accent-color))';
    } else if (progress >= 25) {
        progressBar.style.background = 'linear-gradient(90deg, #4cc9f0, #4361ee)';
    }
}

// Форматирование больших чисел с разделителями
function formatLargeNumber(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, " ");
}

// Форматирование чисел для обычных случаев
function formatNumber(num) {
    return Math.floor(num).toString();
}

// Сохранение результатов в localStorage перед закрытием
function saveResultsBeforeUnload() {
    if (!resultsSent && score > 0) {
        const gameData = {
            gameType: gameType,
            score: score,
            chatId: chatId,
            timestamp: Date.now(),
            totalClicks: totalClicks
        };
        localStorage.setItem('pendingGameResults', JSON.stringify(gameData));
        console.log('Game results saved to localStorage');
    }
}

// Попытка отправить сохраненные результаты при загрузке
async function sendPendingResults() {
    const pendingResults = localStorage.getItem('pendingGameResults');
    if (pendingResults) {
        try {
            const gameData = JSON.parse(pendingResults);
            console.log('Found pending results:', gameData);

            // Восстанавливаем прогресс
            if (gameData.totalClicks) {
                totalClicks = gameData.totalClicks;
                score = gameData.score;
                updateUI();
            }

            // Проверяем, не старые ли это результаты (больше 5 минут)
            if (Date.now() - gameData.timestamp < 5 * 60 * 1000) {
                console.log('Sending pending results...');
                await sendGameResults(gameData.score);
            } else {
                console.log('Pending results are too old, discarding');
            }
        } catch (error) {
            console.error('Error sending pending results:', error);
        } finally {
            // Всегда очищаем, чтобы не пытаться отправлять повторно
            localStorage.removeItem('pendingGameResults');
        }
    }
}

// Инициализация игры
async function initGame() {
    // Сначала пытаемся отправить сохраненные результаты
    await sendPendingResults();
    
    clickArea.addEventListener('click', handleClick);

    clickArea.addEventListener('touchstart', (e) => {
        e.preventDefault();
        handleClick();
    });

    updateUI();
}

// Обработчики для сохранения результатов при закрытии
window.addEventListener('beforeunload', (event) => {
    if (!resultsSent && score > 0) {
        saveResultsBeforeUnload();
        
        // Показываем подтверждение закрытия только если есть неотправленные результаты
        event.preventDefault();
        event.returnValue = 'У вас есть несохраненные результаты игры. Вы уверены, что хотите уйти?';
        return event.returnValue;
    }
});

window.addEventListener('unload', () => {
    if (!resultsSent && score > 0) {
        saveResultsBeforeUnload();
        
        // Пытаемся отправить с помощью sendBeacon (без заголовков)
        const requestBody = {
            gameType: gameType,
            score: score
        };

        if (chatId) {
            requestBody.chatId = chatId;
        }

        // Отправляем без авторизации через sendBeacon
        const data = new Blob([JSON.stringify(requestBody)], {type: 'application/json'});
        navigator.sendBeacon(`${API_BASE_URL}/api/v1/games/complete`, data);
    }
});

// Запуск игры
document.addEventListener('DOMContentLoaded', initGame);