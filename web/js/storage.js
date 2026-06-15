// Local Storage Service
class StorageService {
    constructor() {
        this.prefix = 'glass-weather-';
    }

    setFavorites(cities) {
        localStorage.setItem(this.prefix + 'favorites', JSON.stringify(cities));
    }

    getFavorites() {
        const data = localStorage.getItem(this.prefix + 'favorites');
        return data ? JSON.parse(data) : [];
    }

    addFavorite(city) {
        const favorites = this.getFavorites();
        if (!favorites.find(c => c.id === city.id)) {
            favorites.push(city);
            this.setFavorites(favorites);
        }
    }

    removeFavorite(id) {
        const favorites = this.getFavorites().filter(c => c.id !== id);
        this.setFavorites(favorites);
    }

    setSearchHistory(history) {
        localStorage.setItem(this.prefix + 'search-history', JSON.stringify(history));
    }

    getSearchHistory() {
        const data = localStorage.getItem(this.prefix + 'search-history');
        return data ? JSON.parse(data) : [];
    }

    addSearchHistory(item) {
        let history = this.getSearchHistory();
        history = history.filter(h => h.city !== item.city);
        history.unshift(item);
        history = history.slice(0, 50); // Keep only 50 items
        this.setSearchHistory(history);
    }

    setLastLocation(location) {
        localStorage.setItem(this.prefix + 'last-location', JSON.stringify(location));
    }

    getLastLocation() {
        const data = localStorage.getItem(this.prefix + 'last-location');
        return data ? JSON.parse(data) : null;
    }

    setNotificationSettings(settings) {
        localStorage.setItem(this.prefix + 'notifications', JSON.stringify(settings));
    }

    getNotificationSettings() {
        const data = localStorage.getItem(this.prefix + 'notifications');
        return data ? JSON.parse(data) : {
            isEnabled: true,
            notifyOnRain: true,
            notifyOnStorm: true,
            notifyOnExtremeCold: true,
            notifyOnExtremeHeat: true,
            tempColdThreshold: 0,
            tempHeatThreshold: 35
        };
    }
}
