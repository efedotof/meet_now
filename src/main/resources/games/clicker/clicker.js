// Получаем параметры из URL
const params = new URLSearchParams(window.location.search);
const userId = params.get('userId');
const chatId = params.get('chatId');
const gameType = 'clicker';

let count = 0;

// Проверка наличия обязательных параметров
if (!userId || !chatId) {
    alert("Missing userId or chatId in URL. Example:\n?userId=123&chatId=456");
    throw new Error("Missing userId or chatId");
}

document.getElementById("clickBtn").addEventListener("click", () => {
    count++;
    document.getElementById("clickCount").innerText = count;

    if (count >= 10) {
        alert("Game over! Sending score...");

        fetch('http://localhost:8080/api/v1/games/complete', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                userId: userId,
                chatId: chatId,
                gameType: gameType,
                score: count
            })
        }).then(response => {
            if (response.ok) alert("Score sent!");
            else alert("Failed to send score");
        });
    }
});
