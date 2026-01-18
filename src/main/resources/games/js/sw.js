// Укажите версию кэша для обновления
const CACHE_NAME = 'mna-games-v1.0.0';
const urlsToCache = [
  '/',
  '/index.html',
  '/css/styles.css',
  '/css/auth.css',
  '/js/api.js',
  '/js/auth.js',
  '/js/games.js',
  '/js/main.js',
  '/favicon.png',
  '/icons/Icon-192.png',
  '/icons/Icon-512.png',
  'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css'
];

// Установка Service Worker и кэширование ресурсов
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => {
        console.log('Кэширование ресурсов');
        return cache.addAll(urlsToCache);
      })
  );
});

// Активация Service Worker и удаление старых кэшей
self.addEventListener('activate', event => {
  event.waitUntil(
    caches.keys().then(cacheNames => {
      return Promise.all(
        cacheNames.map(cacheName => {
          if (cacheName !== CACHE_NAME) {
            console.log('Удаление старого кэша:', cacheName);
            return caches.delete(cacheName);
          }
        })
      );
    })
  );
});

// Обработка запросов
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request)
      .then(response => {
        // Возвращаем кэшированный ресурс, если он есть
        if (response) {
          return response;
        }
        
        // Иначе загружаем из сети
        return fetch(event.request)
          .then(response => {
            // Проверяем валидность ответа
            if (!response || response.status !== 200 || response.type !== 'basic') {
              return response;
            }
            
            // Клонируем ответ для кэширования и возврата
            const responseToCache = response.clone();
            
            caches.open(CACHE_NAME)
              .then(cache => {
                cache.put(event.request, responseToCache);
              });
            
            return response;
          });
      })
      .catch(() => {
        // Обработка ошибок - можно вернуть запасную страницу
        console.log('Не удалось загрузить ресурс:', event.request.url);
      })
  );
});