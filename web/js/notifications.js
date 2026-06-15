// Notifications Service
class NotificationsService {
    constructor() {
        this.storage = new StorageService();
    }

    async requestPermission() {
        if (!('Notification' in window)) {
            console.log('このブラウザは通知をサポートしていません');
            return false;
        }

        if (Notification.permission === 'granted') {
            return true;
        }

        if (Notification.permission !== 'denied') {
            const permission = await Notification.requestPermission();
            return permission === 'granted';
        }

        return false;
    }

    showNotification(title, options = {}) {
        if (Notification.permission === 'granted') {
            new Notification(title, {
                badge: '/images/icons/icon-192x192.png',
                icon: '/images/icons/icon-192x192.png',
                ...options
            });
        }
    }

    sendWeatherAlert(weather) {
        const settings = this.storage.getNotificationSettings();
        if (!settings.isEnabled) return;

        const condition = weather.condition.toLowerCase();
        let shouldNotify = false;
        let title = '';
        let body = '';

        if (settings.notifyOnRain && (condition.includes('rain') || condition.includes('drizzle'))) {
            shouldNotify = true;
            title = '🌧️ 雨が降っています';
            body = `現在の天気: ${weather.description}。傘を持つことをお勧めします。`;
        }

        if (settings.notifyOnStorm && (condition.includes('thunder') || condition.includes('storm'))) {
            shouldNotify = true;
            title = '⚡ 雷雨警報';
            body = '⚠️ 雷雨が発生しています。安全な場所に移動してください。';
        }

        if (settings.notifyOnExtremeCold && weather.temp < settings.tempColdThreshold) {
            shouldNotify = true;
            title = '❄️ 極寒警報';
            body = `気温が${weather.temp}°Cまで低下しています。暖かい服装をしてください。`;
        }

        if (settings.notifyOnExtremeHeat && weather.temp > settings.tempHeatThreshold) {
            shouldNotify = true;
            title = '🔥 熱中症警報';
            body = `気温が${weather.temp}°Cに達しています。水分補給と休息を心がけてください。`;
        }

        if (shouldNotify) {
            this.showNotification(title, { body });
        }
    }
}
