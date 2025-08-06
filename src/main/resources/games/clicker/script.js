// script.js
document.addEventListener('DOMContentLoaded', () => {
    // Элементы игры
    const clickArea = document.getElementById('click-area');
    const scoreElement = document.getElementById('score');
    const cpsElement = document.getElementById('cps');
    const totalClicksElement = document.getElementById('total-clicks');
    const upgradesGrid = document.querySelector('.upgrades-grid');
    const effectsContainer = document.getElementById('effects-container');
    const progressBar = document.getElementById('progress-bar');
    
    // Переменные игры
    let score = 0;
    let cps = 0; // Кликов в секунду
    let totalClicks = 0;
    let lastClickTime = Date.now();
    let autoClickers = 0;
    
    // Улучшения
    const upgrades = [
        {
            id: 1,
            name: "Автокликер",
            icon: "fa-robot",
            description: "Автоматически кликает 1 раз в секунду",
            baseCost: 15,
            level: 0,
            effect: () => { autoClickers += 1; }
        },
        {
            id: 2,
            name: "Усиленный клик",
            icon: "fa-hand-fist",
            description: "Увеличивает силу каждого клика",
            baseCost: 50,
            level: 0,
            effect: () => { /* Эффект применяется в функции клика */ }
        },
        {
            id: 3,
            name: "Золотой палец",
            icon: "fa-fingerprint",
            description: "Увеличивает шанс на бонусные очки",
            baseCost: 120,
            level: 0,
            effect: () => { /* Эффект применяется в функции клика */ }
        },
        {
            id: 4,
            name: "Кристальная мудрость",
            icon: "fa-gem",
            description: "Увеличивает доход от всех источников",
            baseCost: 300,
            level: 0,
            effect: () => { /* Эффект применяется глобально */ }
        }
    ];
    
    // Инициализация улучшений
    function initUpgrades() {
        upgradesGrid.innerHTML = '';
        upgrades.forEach(upgrade => {
            const upgradeElement = document.createElement('div');
            upgradeElement.className = 'upgrade';
            upgradeElement.innerHTML = `
                <div class="upgrade-name">
                    <i class="fas ${upgrade.icon}"></i>
                    ${upgrade.name}
                </div>
                <div class="upgrade-description">${upgrade.description}</div>
                <div class="upgrade-cost">
                    <span>Цена: ${calculateCost(upgrade)} очков</span>
                    <span class="upgrade-level">Уровень: ${upgrade.level}</span>
                </div>
            `;
            
            upgradeElement.addEventListener('click', () => {
                buyUpgrade(upgrade);
            });
            
            upgradesGrid.appendChild(upgradeElement);
        });
    }
    
    // Расчет стоимости улучшения
    function calculateCost(upgrade) {
        return Math.floor(upgrade.baseCost * Math.pow(1.5, upgrade.level));
    }
    
    // Покупка улучшения
    function buyUpgrade(upgrade) {
        const cost = calculateCost(upgrade);
        if (score >= cost) {
            score -= cost;
            upgrade.level++;
            upgrade.effect();
            updateUI();
            createEffect(`+${upgrade.name}`, clickArea);
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
        
        // Удаление эффекта после завершения анимации
        setTimeout(() => {
            effect.remove();
        }, 1000);
    }
    
    // Обработка клика
    function handleClick() {
        const now = Date.now();
        const timeDiff = (now - lastClickTime) / 1000; // В секундах
        
        // Расчет CPS (кликов в секунду)
        if (timeDiff > 0) {
            cps = 1 / timeDiff;
        }
        
        // Расчет очков за клик
        let clickValue = 1;
        
        // Бонус от улучшений
        const clickUpgrade = upgrades.find(u => u.id === 2);
        if (clickUpgrade && clickUpgrade.level > 0) {
            clickValue += clickUpgrade.level * 0.5;
        }
        
        // Шанс на бонусные очки
        const bonusUpgrade = upgrades.find(u => u.id === 3);
        if (bonusUpgrade && bonusUpgrade.level > 0) {
            const bonusChance = Math.min(0.3, bonusUpgrade.level * 0.05);
            if (Math.random() < bonusChance) {
                clickValue *= 3;
                createEffect(`x3 БОНУС!`, clickArea);
            }
        }
        
        // Глобальный множитель
        const globalUpgrade = upgrades.find(u => u.id === 4);
        if (globalUpgrade && globalUpgrade.level > 0) {
            clickValue *= 1 + (globalUpgrade.level * 0.1);
        }
        
        // Округление и добавление очков
        clickValue = Math.round(clickValue * 10) / 10;
        score += clickValue;
        totalClicks++;
        lastClickTime = now;
        
        // Создание эффекта
        createEffect(`+${clickValue}`, clickArea);
        
        // Обновление интерфейса
        updateUI();
    }
    
    // Автоклик
    function autoClick() {
        if (autoClickers > 0) {
            const autoClickValue = autoClickers * 0.5;
            score += autoClickValue;
            createEffect(`+${autoClickValue.toFixed(1)}`, clickArea);
            updateUI();
        }
    }
    
    // Обновление интерфейса
    function updateUI() {
        scoreElement.textContent = formatNumber(score);
        cpsElement.textContent = cps.toFixed(1);
        totalClicksElement.textContent = formatNumber(totalClicks);
        
        // Обновление прогресс-бара
        const progress = Math.min(100, (score / 1000000) * 100);
        progressBar.style.width = `${progress}%`;
        
        // Обновление улучшений
        const upgradeElements = document.querySelectorAll('.upgrade');
        upgrades.forEach((upgrade, index) => {
            const costElement = upgradeElements[index].querySelector('.upgrade-cost span:first-child');
            const levelElement = upgradeElements[index].querySelector('.upgrade-level');
            
            costElement.textContent = `Цена: ${formatNumber(calculateCost(upgrade))} очков`;
            levelElement.textContent = `Уровень: ${upgrade.level}`;
            
            // Если недостаточно очков, делаем кнопку менее заметной
            if (score < calculateCost(upgrade)) {
                upgradeElements[index].style.opacity = '0.6';
            } else {
                upgradeElements[index].style.opacity = '1';
            }
        });
    }
    
    // Форматирование чисел
    function formatNumber(num) {
        if (num >= 1000000) {
            return (num / 1000000).toFixed(1) + 'M';
        }
        if (num >= 1000) {
            return (num / 1000).toFixed(1) + 'K';
        }
        return Math.floor(num);
    }
    
    // Инициализация игры
    function initGame() {
        // Обработчик клика
        clickArea.addEventListener('click', handleClick);
        
        // Обработчик для мобильных устройств
        clickArea.addEventListener('touchstart', (e) => {
            e.preventDefault();
            handleClick();
        });
        
        // Автоклик каждую секунду
        setInterval(autoClick, 1000);
        
        // Обновление CPS каждую секунду
        setInterval(() => {
            const now = Date.now();
            const timeDiff = (now - lastClickTime) / 1000;
            
            // Если с последнего клика прошло больше секунды, сбрасываем CPS
            if (timeDiff > 1) {
                cps = 0;
                updateUI();
            }
        }, 1000);
        
        // Инициализация улучшений
        initUpgrades();
        
        // Начальное обновление UI
        updateUI();
    }
    
    // Запуск игры
    initGame();
});