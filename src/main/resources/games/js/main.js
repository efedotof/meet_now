let authManager;
let gamesManager;

document.addEventListener('DOMContentLoaded', () => {
    authManager = new AuthManager();
    gamesManager = new GamesManager();
    
    document.getElementById('user-agreement')?.addEventListener('click', (e) => {
        e.preventDefault();
        showAgreementModal();
    });
    
    document.getElementById('privacy-policy')?.addEventListener('click', (e) => {
        e.preventDefault();
        showPrivacyModal();
    });
});

function showAgreementModal() {
    const modal = document.getElementById('agreement-modal');
    const body = modal.querySelector('.modal-body');
    
    body.innerHTML = `
        <h4>Пользовательское соглашение MNA</h4>
        <p><strong>Последнее обновление:</strong> ${new Date().toLocaleDateString()}</p>
        <p>Добро пожаловать в MNA! Пожалуйста, внимательно ознакомьтесь с настоящим Соглашением.</p>
        <h5>1. Принятие условий</h5>
        <p>Используя MNA, вы подтверждаете, что прочитали, поняли и соглашаетесь соблюдать настоящее Соглашение.</p>
        <h5>2. Описание сервиса</h5>
        <p>MNA — это приложение для знакомств, где первое впечатление строится на общении, а не на внешности.</p>
        <h5>3. Регистрация и учетная запись</h5>
        <p>Для доступа к некоторым функциям вам необходимо зарегистрировать учетную запись.</p>
        <h5>4. Правила поведения</h5>
        <p>Запрещается:
        • Размещать оскорбительный или незаконный контент
        • Притворяться другим человеком
        • Использовать сервис для спама или мошенничества</p>
        <h5>5. Конфиденциальность</h5>
        <p>Мы ценим вашу конфиденциальность.</p>
        <h5>6. Изменения в Соглашении</h5>
        <p>Мы можем время от времени обновлять настоящее Соглашение.</p>
        <p>Если у вас есть вопросы относительно настоящего Соглашения, свяжитесь с нами по адресу: mna_dev@mnapp.ru</p>
    `;
    
    modal.style.display = 'block';
}

function showPrivacyModal() {
    const modal = document.getElementById('privacy-modal');
    const body = modal.querySelector('.modal-body');
    
    body.innerHTML = `
        <h4>Политика конфиденциальности MNA</h4>
        <p><strong>Последнее обновление:</strong> ${new Date().toLocaleDateString()}</p>
        <p>Ваша конфиденциальность важна для нас.</p>
        <h5>1. Собираемая информация</h5>
        <p>Мы можем собирать следующую информацию:
        • Регистрационные данные (имя пользователя, email)
        • Профильную информацию (интересы, описание)
        • Данные об использовании приложения
        • Техническую информацию (IP-адрес, тип устройства)</p>
        <h5>2. Использование информации</h5>
        <p>Мы используем собранную информацию для:
        • Предоставления и улучшения наших услуг
        • Персонализации вашего опыта
        • Обеспечения безопасности
        • Связи с вами</p>
        <h5>3. Защита информации</h5>
        <p>Мы принимаем разумные меры для защиты вашей информации.</p>
        <h5>4. Обмен информацией</h5>
        <p>Мы не продаем и не передаем вашу личную информацию третьим лицам.</p>
        <h5>5. Ваши права</h5>
        <p>Вы имеете право:
        • Получить доступ к своей информации
        • Исправить неточные данные
        • Удалить свою учетную запись
        • Возразить против обработки данных</p>
        <h5>6. Контакты</h5>
        <p>Если у вас есть вопросы о нашей Политике конфиденциальности, свяжитесь с нами:</p>
        <p>Email: mna_dev@mnapp.ru<br>
        Telegram: @meetnadev</p>
    `;
    
    modal.style.display = 'block';
}

window.openGame = function(url) {
    if (window.gamesManager) {
        window.gamesManager.openGame(url);
    }
};

console.log('MNA Games initialized');