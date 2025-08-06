document.addEventListener('DOMContentLoaded', () => {
    // Элементы игры
    const gameContainer = document.querySelector('.game-container');
    const player = document.getElementById('player');
    const scoreElement = document.getElementById('score');
    const livesElement = document.getElementById('lives');
    const startBtn = document.getElementById('start-btn');
    const pauseBtn = document.getElementById('pause-btn');
    const resetBtn = document.getElementById('reset-btn');
    const gameOverScreen = document.getElementById('game-over');
    const finalScoreElement = document.getElementById('final-score');
    const restartBtn = document.getElementById('restart-btn');
    
    // Переменные игры
    let gameActive = false;
    let gamePaused = false;
    let score = 0;
    let lives = 3;
    let playerPosition = 50; // в процентах от ширины экрана
    let gameLoop;
    let starInterval;
    let stars = [];
    
    // Инициализация игры
    function initGame() {
        score = 0;
        lives = 3;
        playerPosition = 50;
        scoreElement.textContent = score;
        livesElement.textContent = lives;
        
        // Очистка экрана от звезд
        stars.forEach(star => star.remove());
        stars = [];
        
        // Позиция игрока
        updatePlayerPosition();
        
        gameOverScreen.style.display = 'none';
        gameActive = true;
        gamePaused = false;
        
        // Запуск игрового цикла
        if (gameLoop) clearInterval(gameLoop);
        gameLoop = setInterval(updateGame, 20);
        
        // Создание звезд
        if (starInterval) clearInterval(starInterval);
        starInterval = setInterval(createStar, 1000);
    }
    
    // Создание новой звезды
    function createStar() {
        if (!gameActive || gamePaused) return;
        
        const star = document.createElement('div');
        star.classList.add('star');
        
        // Случайная позиция по горизонтали
        const left = Math.random() * 90 + 5;
        star.style.left = `${left}%`;
        
        // Случайная скорость
        const speed = Math.random() * 3 + 2;
        star.dataset.speed = speed;
        
        gameContainer.appendChild(star);
        stars.push(star);
    }
    
    // Обновление игрового состояния
    function updateGame() {
        if (!gameActive || gamePaused) return;
        
        // Перемещение звезд
        for (let i = stars.length - 1; i >= 0; i--) {
            const star = stars[i];
            const top = parseFloat(star.style.top || '0') + parseFloat(star.dataset.speed);
            star.style.top = `${top}%`;
            
            // Проверка столкновения с игроком
            if (top > 85) {
                const playerRect = player.getBoundingClientRect();
                const starRect = star.getBoundingClientRect();
                
                if (
                    starRect.left < playerRect.right &&
                    starRect.right > playerRect.left &&
                    starRect.bottom > playerRect.top
                ) {
                    // Звезда поймана
                    star.remove();
                    stars.splice(i, 1);
                    score += 10;
                    scoreElement.textContent = score;
                    playCatchSound();
                    continue;
                }
            }
            
            // Проверка ухода за пределы экрана
            if (top > 100) {
                star.remove();
                stars.splice(i, 1);
                lives--;
                livesElement.textContent = lives;
                playMissSound();
                
                if (lives <= 0) {
                    endGame();
                }
            }
        }
    }
    
    // Обновление позиции игрока
    function updatePlayerPosition() {
        player.style.left = `${playerPosition}%`;
    }
    
    // Обработка движения мыши
    gameContainer.addEventListener('mousemove', (e) => {
        if (!gameActive || gamePaused) return;
        
        const rect = gameContainer.getBoundingClientRect();
        const relativeX = e.clientX - rect.left;
        playerPosition = (relativeX / rect.width) * 100;
        
        // Ограничение позиции игрока в пределах экрана
        if (playerPosition < 5) playerPosition = 5;
        if (playerPosition > 95) playerPosition = 95;
        
        updatePlayerPosition();
    });
    
    // Обработка касаний для мобильных устройств
    gameContainer.addEventListener('touchmove', (e) => {
        if (!gameActive || gamePaused) return;
        
        e.preventDefault();
        const touch = e.touches[0];
        const rect = gameContainer.getBoundingClientRect();
        const relativeX = touch.clientX - rect.left;
        playerPosition = (relativeX / rect.width) * 100;
        
        // Ограничение позиции игрока в пределах экрана
        if (playerPosition < 5) playerPosition = 5;
        if (playerPosition > 95) playerPosition = 95;
        
        updatePlayerPosition();
    });
    
    // Завершение игры
    function endGame() {
        gameActive = false;
        clearInterval(gameLoop);
        clearInterval(starInterval);
        
        finalScoreElement.textContent = score;
        gameOverScreen.style.display = 'flex';
    }
    
    // Звуковые эффекты
    function playCatchSound() {
        // В реальном приложении здесь будет воспроизведение звука
        player.style.transform = 'scale(1.2)';
        setTimeout(() => {
            player.style.transform = 'scale(1)';
        }, 100);
    }
    
    function playMissSound() {
        // В реальном приложении здесь будет воспроизведение звука
        gameContainer.style.backgroundColor = 'rgba(255, 0, 0, 0.3)';
        setTimeout(() => {
            gameContainer.style.backgroundColor = 'rgba(0, 0, 0, 0.4)';
        }, 200);
    }
    
    // Обработчики кнопок
    startBtn.addEventListener('click', () => {
        if (!gameActive) {
            initGame();
        }
        gamePaused = false;
    });
    
    pauseBtn.addEventListener('click', () => {
        gamePaused = !gamePaused;
        pauseBtn.textContent = gamePaused ? 'Продолжить' : 'Пауза';
    });
    
    resetBtn.addEventListener('click', () => {
        initGame();
    });
    
    restartBtn.addEventListener('click', () => {
        initGame();
    });
    
    // Инициализация при загрузке
    initGame();
});