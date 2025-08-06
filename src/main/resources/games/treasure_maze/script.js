// Конфигурация игры
const config = {
    rows: 15,
    cols: 15,
    treasures: 5,
    levels: 3,
    baseScorePerTreasure: 100,
    baseScorePerLevel: 500,
    timeBonusPerSecond: 10,
    stepPenalty: 5
};

// Состояние игры
const gameState = {
    player: {x: 0, y: 0},
    exit: {x: 0, y: 0},
    treasures: [],
    walls: [],
    treasureCount: 0,
    steps: 0,
    level: 1,
    gameOver: false,
    totalScore: 0,
    levelStartTime: 0,
    levelElapsedTime: 0,
    timerInterval: null
};

// Элементы DOM
const maze = document.getElementById('maze');
const mazeContainer = document.getElementById('mazeContainer');
const treasureCountEl = document.getElementById('treasureCount');
const stepsEl = document.getElementById('steps');
const levelEl = document.getElementById('level');
const timerEl = document.getElementById('timer');
const totalScoreEl = document.getElementById('totalScore');
const message = document.getElementById('message');
const messageTitle = document.getElementById('messageTitle');
const messageText = document.getElementById('messageText');
const levelStatsEl = document.getElementById('levelStats');
const restartBtn = document.getElementById('restartBtn');

// Переменные для обработки свайпов
let touchStartX = 0;
let touchStartY = 0;
let touchEndX = 0;
let touchEndY = 0;
const minSwipeDistance = 50;

// Создаем индикатор свайпа
const swipeIndicator = document.createElement('div');
swipeIndicator.classList.add('swipe-indicator');
swipeIndicator.textContent = 'Свайпайте для движения';
mazeContainer.appendChild(swipeIndicator);

// Показываем индикатор свайпа на мобильных устройствах
function showSwipeIndicator() {
    if (window.innerWidth <= 768) {
        swipeIndicator.classList.add('show');
        
        setTimeout(() => {
            swipeIndicator.classList.remove('show');
        }, 3000);
    }
}

// Запуск таймера уровня
function startLevelTimer() {
    gameState.levelStartTime = Date.now();
    
    if (gameState.timerInterval) {
        clearInterval(gameState.timerInterval);
    }
    
    gameState.timerInterval = setInterval(() => {
        gameState.levelElapsedTime = Date.now() - gameState.levelStartTime;
        updateTimerDisplay();
    }, 1000);
}

// Обновление отображения таймера
function updateTimerDisplay() {
    const totalSeconds = Math.floor(gameState.levelElapsedTime / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    
    timerEl.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
}

// Инициализация игры
function initGame() {
    gameState.treasureCount = 0;
    gameState.steps = 0;
    gameState.gameOver = false;
    gameState.treasures = [];
    gameState.levelElapsedTime = 0;
    
    // Обновляем UI
    treasureCountEl.textContent = gameState.treasureCount;
    stepsEl.textContent = gameState.steps;
    levelEl.textContent = gameState.level;
    totalScoreEl.textContent = gameState.totalScore;
    message.classList.remove('show');
    
    // Запускаем таймер уровня
    startLevelTimer();
    updateTimerDisplay();
    
    // Создаем лабиринт
    createMaze();
    renderMaze();
    
    // Показываем индикатор свайпа
    showSwipeIndicator();
}

// Создание лабиринта
function createMaze() {
    maze.innerHTML = '';
    gameState.walls = [];
    
    maze.style.gridTemplateColumns = `repeat(${config.cols}, 1fr)`;
    maze.style.gridTemplateRows = `repeat(${config.rows}, 1fr)`;
    
    for (let y = 0; y < config.rows; y++) {
        for (let x = 0; x < config.cols; x++) {
            const cell = document.createElement('div');
            cell.classList.add('cell');
            cell.dataset.x = x;
            cell.dataset.y = y;
            maze.appendChild(cell);
        }
    }
    
    generateWalls();
    
    // Размещаем игрока в безопасной позиции
    gameState.player = {x: 1, y: 1};
    
    // Размещаем выход в противоположном углу
    gameState.exit = {x: config.cols - 2, y: config.rows - 2};
    
    placeTreasures();
}

// Генерация стен
function generateWalls() {
    // Базовые стены по краям
    for (let x = 0; x < config.cols; x++) {
        for (let y = 0; y < config.rows; y++) {
            if (x === 0 || y === 0 || x === config.cols - 1 || y === config.rows - 1) {
                gameState.walls.push({x, y});
            }
        }
    }
    
    // Дополнительные стены в зависимости от уровня
    const wallCount = 20 + gameState.level * 10;
    
    for (let i = 0; i < wallCount; i++) {
        const x = Math.floor(Math.random() * (config.cols - 2)) + 1;
        const y = Math.floor(Math.random() * (config.rows - 2)) + 1;
        
        if ((x === gameState.player.x && y === gameState.player.y) || 
            (x === gameState.exit.x && y === gameState.exit.y) ||
            gameState.walls.some(wall => wall.x === x && wall.y === y)) {
            continue;
        }
        
        gameState.walls.push({x, y});
    }
}

// Размещение сокровищ
function placeTreasures() {
    gameState.treasures = [];
    
    for (let i = 0; i < config.treasures; i++) {
        let treasure;
        let validPosition = false;
        let attempts = 0;
        
        while (!validPosition && attempts < 100) {
            const x = Math.floor(Math.random() * (config.cols - 2)) + 1;
            const y = Math.floor(Math.random() * (config.rows - 2)) + 1;
            
            if ((x === gameState.player.x && y === gameState.player.y) || 
                (x === gameState.exit.x && y === gameState.exit.y) ||
                gameState.walls.some(wall => wall.x === x && wall.y === y) ||
                gameState.treasures.some(t => t.x === x && t.y === y)) {
                attempts++;
                continue;
            }
            
            treasure = {x, y};
            validPosition = true;
        }
        
        if (validPosition) {
            gameState.treasures.push(treasure);
        }
    }
}

// Отрисовка лабиринта
function renderMaze() {
    const cells = document.querySelectorAll('.cell');
    cells.forEach(cell => {
        cell.className = 'cell';
        cell.innerHTML = '';
    });
    
    gameState.walls.forEach(wall => {
        const cell = document.querySelector(`.cell[data-x="${wall.x}"][data-y="${wall.y}"]`);
        if (cell) cell.classList.add('wall');
    });
    
    gameState.treasures.forEach(treasure => {
        const cell = document.querySelector(`.cell[data-x="${treasure.x}"][data-y="${treasure.y}"]`);
        if (cell) {
            const treasureEl = document.createElement('div');
            treasureEl.classList.add('treasure');
            cell.appendChild(treasureEl);
        }
    });
    
    const exitCell = document.querySelector(`.cell[data-x="${gameState.exit.x}"][data-y="${gameState.exit.y}"]`);
    if (exitCell) {
        const exitEl = document.createElement('div');
        exitEl.classList.add('exit');
        exitCell.appendChild(exitEl);
    }
    
    const playerCell = document.querySelector(`.cell[data-x="${gameState.player.x}"][data-y="${gameState.player.y}"]`);
    if (playerCell) {
        const playerEl = document.createElement('div');
        playerEl.classList.add('player');
        playerCell.appendChild(playerEl);
    }
}

// Перемещение игрока
function movePlayer(dx, dy) {
    if (gameState.gameOver) return;
    
    const newX = gameState.player.x + dx;
    const newY = gameState.player.y + dy;
    
    if (newX < 0 || newY < 0 || newX >= config.cols || newY >= config.rows) {
        return;
    }
    
    if (gameState.walls.some(wall => wall.x === newX && wall.y === newY)) {
        return;
    }
    
    gameState.player.x = newX;
    gameState.player.y = newY;
    gameState.steps++;
    
    stepsEl.textContent = gameState.steps;
    
    const treasureIndex = gameState.treasures.findIndex(t => t.x === newX && t.y === newY);
    if (treasureIndex !== -1) {
        gameState.treasures.splice(treasureIndex, 1);
        gameState.treasureCount++;
        treasureCountEl.textContent = gameState.treasureCount;
    }
    
    checkWinCondition();
    renderMaze();
}

// Расчет очков за уровень
function calculateLevelScore() {
    // Базовые очки за уровень
    let score = config.baseScorePerLevel * gameState.level;
    
    // Очки за собранные сокровища
    score += gameState.treasureCount * config.baseScorePerTreasure;
    
    // Бонус за скорость (чем быстрее, тем больше бонус)
    const maxTimeBonus = 30000; // 30 секунд
    const timeBonus = Math.max(0, maxTimeBonus - gameState.levelElapsedTime);
    score += Math.floor(timeBonus / 1000) * config.timeBonusPerSecond;
    
    // Штраф за шаги
    score -= gameState.steps * config.stepPenalty;
    
    // Очки не могут быть отрицательными
    return Math.max(100, score);
}

// Переход на следующий уровень
function nextLevel() {
    if (gameState.level < config.levels) {
        gameState.level++;
        initGame();
    } else {
        // Игра завершена
        gameState.gameOver = true;
        messageTitle.textContent = 'Победа!';
        messageText.textContent = 'Вы прошли все уровни!';
        levelStatsEl.innerHTML = `
            <div>Итоговый счет: <strong>${gameState.totalScore}</strong></div>
            <div>Общее время: <strong>${formatTime(gameState.totalTime)}</strong></div>
            <div>Всего шагов: <strong>${gameState.totalSteps}</strong></div>
        `;
        message.classList.add('show');
    }
}

// Форматирование времени
function formatTime(ms) {
    const totalSeconds = Math.floor(ms / 1000);
    const minutes = Math.floor(totalSeconds / 60);
    const seconds = totalSeconds % 60;
    return `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;
}

// Проверка условий победы
function checkWinCondition() {
    if (gameState.player.x === gameState.exit.x && gameState.player.y === gameState.exit.y) {
        if (gameState.treasureCount === config.treasures) {
            // Останавливаем таймер
            clearInterval(gameState.timerInterval);
            gameState.timerInterval = null;
            
            // Рассчитываем очки за уровень
            const levelScore = calculateLevelScore();
            gameState.totalScore += levelScore;
            
            // Обновляем общий счет
            totalScoreEl.textContent = gameState.totalScore;
            
            // Форматируем время уровня
            const levelTime = formatTime(gameState.levelElapsedTime);
            
            // Показываем сообщение о победе
            messageTitle.textContent = `Уровень ${gameState.level} пройден!`;
            messageText.textContent = 'Отличная работа!';
            
            levelStatsEl.innerHTML = `
                <div>Время: <strong>${levelTime}</strong></div>
                <div>Шаги: <strong>${gameState.steps}</strong></div>
                <div>Сокровищ: <strong>${gameState.treasureCount}/${config.treasures}</strong></div>
                <div>Очки за уровень: <strong>${levelScore}</strong></div>
                <div>Общий счет: <strong>${gameState.totalScore}</strong></div>
            `;
            
            message.classList.add('show');
            
            // Автоматический переход на следующий уровень через 3 секунды
            setTimeout(() => {
                if (gameState.level < config.levels) {
                    message.classList.remove('show');
                    nextLevel();
                }
            }, 3000);
        }
    }
}

// Обработчики событий
document.querySelector('.up').addEventListener('click', () => movePlayer(0, -1));
document.querySelector('.down').addEventListener('click', () => movePlayer(0, 1));
document.querySelector('.left').addEventListener('click', () => movePlayer(-1, 0));
document.querySelector('.right').addEventListener('click', () => movePlayer(1, 0));
document.querySelector('.restart').addEventListener('click', () => {
    gameState.level = 1;
    gameState.totalScore = 0;
    initGame();
});
restartBtn.addEventListener('click', () => {
    if (gameState.level >= config.levels) {
        gameState.level = 1;
        gameState.totalScore = 0;
    }
    message.classList.remove('show');
    initGame();
});

// Обработка клавиатуры
document.addEventListener('keydown', (e) => {
    if (['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight'].includes(e.key)) {
        e.preventDefault();
    }
    
    switch(e.key) {
        case 'ArrowUp': movePlayer(0, -1); break;
        case 'ArrowDown': movePlayer(0, 1); break;
        case 'ArrowLeft': movePlayer(-1, 0); break;
        case 'ArrowRight': movePlayer(1, 0); break;
        case 'r': 
            gameState.level = 1;
            gameState.totalScore = 0;
            initGame(); 
            break;
    }
});

// Обработка свайпов для мобильных устройств
mazeContainer.addEventListener('touchstart', (e) => {
    touchStartX = e.changedTouches[0].screenX;
    touchStartY = e.changedTouches[0].screenY;
});

mazeContainer.addEventListener('touchend', (e) => {
    touchEndX = e.changedTouches[0].screenX;
    touchEndY = e.changedTouches[0].screenY;
    handleSwipe();
});

function handleSwipe() {
    const distX = touchEndX - touchStartX;
    const distY = touchEndY - touchStartY;
    
    if (Math.abs(distX) > Math.abs(distY) && Math.abs(distX) > minSwipeDistance) {
        if (distX > 0) {
            movePlayer(1, 0);
        } else {
            movePlayer(-1, 0);
        }
    } 
    else if (Math.abs(distY) > Math.abs(distX) && Math.abs(distY) > minSwipeDistance) {
        if (distY > 0) {
            movePlayer(0, 1);
        } else {
            movePlayer(0, -1);
        }
    }
}

document.querySelectorAll('.control-btn').forEach(button => {
    button.addEventListener('touchstart', (e) => {
        e.preventDefault();
        e.stopPropagation();
    });
});

// Инициализируем игру
initGame();