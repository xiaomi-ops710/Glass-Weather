const CACHE_NAME = 'glass-weather-v1';
const urlsToCache = [
    '/',
    '/index.html',
    '/css/styles.css',
    '/css/animations.css',
    '/js/main.js',
    '/js/weather.js',
    '/js/storage.js',
    '/js/notifications.js'
];

// インストール
self.addEventListener('install', event => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => cache.addAll(urlsToCache))
            .then(() => self.skipWaiting())
    );
});

// アクティベート
self.addEventListener('activate', event => {
    event.waitUntil(
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames.map(cacheName => {
                    if (cacheName !== CACHE_NAME) {
                        return caches.delete(cacheName);
                    }
                })
            );
        }).then(() => self.clients.claim())
    );
});

// フェッチ
self.addEventListener('fetch', event => {
    // GET リクエストのみ対応
    if (event.request.method !== 'GET') {
        return;
    }

    event.respondWith(
        caches.match(event.request)
            .then(response => {
                if (response) {
                    return response;
                }

                return fetch(event.request).then(response => {
                    if (!response || response.status !== 200 || response.type !== 'basic') {
                        return response;
                    }

                    const responseToCache = response.clone();
                    caches.open(CACHE_NAME)
                        .then(cache => {
                            cache.put(event.request, responseToCache);
                        });

                    return response;
                });
            })
            .catch(() => {
                // オフライン時のフォールバック
                return new Response('オフラインです。接続を確認してください。');
            })
    );
});
