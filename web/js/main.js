const { createApp, ref, reactive, computed, onMounted, watch } = Vue;

const app = createApp({
    template: `
        <div class="app" :style="{ backgroundColor: backgroundGradient }">
            <!-- Weather Animations -->
            <div class="weather-animations">
                <div v-if="showRain" class="rain-container">
                    <div v-for="i in 50" :key="'rain-' + i" class="rain-drop" :style="randomRainPosition()"></div>
                </div>
                <div v-if="showSnow" class="snow-container">
                    <div v-for="i in 30" :key="'snow-' + i" class="snow-flake" :style="randomSnowPosition()"></div>
                </div>
                <div v-if="showThunder" class="lightning"></div>
                <div v-if="showClouds" class="clouds-container">
                    <div v-for="i in 5" :key="'cloud-' + i" class="cloud">☁️</div>
                </div>
            </div>

            <!-- Main Content -->
            <div class="main-content">
                <!-- Header -->
                <header class="header">
                    <div>
                        <h1>Glass Weather</h1>
                        <p class="location">{{ currentLocation }}</p>
                    </div>
                    <div class="header-actions">
                        <button class="btn-icon" @click="toggleFavorites" title="お気に入り">
                            <span>⭐</span>
                        </button>
                        <button class="btn-icon" @click="toggleSettings" title="設定">
                            <span>⚙️</span>
                        </button>
                    </div>
                </header>

                <!-- Content Area -->
                <div class="content-area">
                    <!-- Loading State -->
                    <div v-if="isLoading" class="loading-container">
                        <div class="loading"></div>
                        <p>天気情報を取得中...</p>
                    </div>

                    <!-- Error State -->
                    <div v-else-if="errorMessage" class="error-container">
                        <div class="glass-card error">
                            <h3>⚠️ エラーが発生しました</h3>
                            <p>{{ errorMessage }}</p>
                            <button class="btn-primary" @click="refreshWeather">再試行</button>
                        </div>
                    </div>

                    <!-- Weather Display -->
                    <div v-else-if="weather" class="weather-display">
                        <!-- Main Weather Card -->
                        <div class="glass-card main-weather">
                            <div class="weather-icon">{{ getWeatherEmoji() }}</div>
                            <div class="temperature">
                                <span class="temp">{{ Math.round(weather.temp) }}°</span>
                                <span class="unit">C</span>
                            </div>
                            <p class="condition">{{ weather.description }}</p>
                            <p class="feels-like">体感気温: {{ Math.round(weather.feelsLike) }}°C</p>
                        </div>

                        <!-- Weather Details Grid -->
                        <div class="details-grid">
                            <div class="glass-card detail-item">
                                <div class="detail-label">💧 湿度</div>
                                <div class="detail-value">{{ weather.humidity }}%</div>
                            </div>
                            <div class="glass-card detail-item">
                                <div class="detail-label">💨 風速</div>
                                <div class="detail-value">{{ weather.windSpeed.toFixed(1) }} m/s</div>
                            </div>
                            <div class="glass-card detail-item">
                                <div class="detail-label">🏔️ 気圧</div>
                                <div class="detail-value">{{ weather.pressure }} hPa</div>
                            </div>
                            <div class="glass-card detail-item">
                                <div class="detail-label">👁️ 視程</div>
                                <div class="detail-value">{{ (weather.visibility / 1000).toFixed(1) }} km</div>
                            </div>
                            <div class="glass-card detail-item">
                                <div class="detail-label">☁️ 雲</div>
                                <div class="detail-value">{{ weather.clouds }}%</div>
                            </div>
                            <div class="glass-card detail-item">
                                <div class="detail-label">🌅 日出/日没</div>
                                <div class="detail-value small">{{ formatTime(weather.sunrise) }} / {{ formatTime(weather.sunset) }}</div>
                            </div>
                        </div>

                        <!-- Forecast -->
                        <div v-if="forecast.length > 0" class="forecast-section">
                            <h2>5日間予報</h2>
                            <div class="forecast-grid">
                                <div v-for="day in forecast" :key="day.date" class="glass-card forecast-item">
                                    <p class="forecast-date">{{ formatDate(day.date) }}</p>
                                    <div class="forecast-emoji">{{ getWeatherEmoji(day.condition) }}</div>
                                    <div class="forecast-temps">
                                        <span class="max">{{ Math.round(day.tempMax) }}°</span>
                                        <span class="min">{{ Math.round(day.tempMin) }}°</span>
                                    </div>
                                    <p class="forecast-precip">{{ Math.round(day.precipitation) }}% 降水</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Footer -->
                <footer class="footer">
                    <button class="btn-primary" @click="refreshWeather">🔄 更新</button>
                </footer>
            </div>

            <!-- Favorites Modal -->
            <div v-if="showFavoritesModal" class="modal-overlay" @click="toggleFavorites">
                <div class="modal glass-card" @click.stop>
                    <div class="modal-header">
                        <h2>お気に入り都市</h2>
                        <button class="btn-icon" @click="toggleFavorites">✕</button>
                    </div>
                    <div class="modal-content">
                        <div v-if="favorites.length === 0" class="empty-state">
                            <p>お気に入り都市がありません</p>
                        </div>
                        <div v-else class="favorites-list">
                            <div v-for="city in favorites" :key="city.id" class="favorite-item">
                                <div class="favorite-info">
                                    <h3>{{ city.name }}</h3>
                                    <p>{{ city.country }}</p>
                                </div>
                                <div class="favorite-actions">
                                    <button @click="selectFavorite(city)" title="選択">➜</button>
                                    <button @click="removeFavorite(city.id)" title="削除">🗑️</button>
                                </div>
                            </div>
                        </div>
                        <input v-model="searchCity" type="search" placeholder="都市を検索..." class="search-input">
                        <div v-if="searchResults.length > 0" class="search-results">
                            <div v-for="result in searchResults" :key="result.id" class="search-result" @click="addFavorite(result)">
                                <span>+ {{ result.name }}, {{ result.country }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Settings Modal -->
            <div v-if="showSettingsModal" class="modal-overlay" @click="toggleSettings">
                <div class="modal glass-card" @click.stop>
                    <div class="modal-header">
                        <h2>設定</h2>
                        <button class="btn-icon" @click="toggleSettings">✕</button>
                    </div>
                    <div class="modal-content">
                        <div class="settings-section">
                            <h3>通知設定</h3>
                            <label class="toggle">
                                <input v-model="notificationSettings.isEnabled" type="checkbox">
                                <span>通知を有効にする</span>
                            </label>
                            <div v-if="notificationSettings.isEnabled" class="nested-settings">
                                <label class="toggle">
                                    <input v-model="notificationSettings.notifyOnRain" type="checkbox">
                                    <span>雨の時に通知</span>
                                </label>
                                <label class="toggle">
                                    <input v-model="notificationSettings.notifyOnStorm" type="checkbox">
                                    <span>雷雨の時に通知</span>
                                </label>
                                <label class="toggle">
                                    <input v-model="notificationSettings.notifyOnExtremeCold" type="checkbox">
                                    <span>極寒の時に通知</span>
                                </label>
                                <label class="toggle">
                                    <input v-model="notificationSettings.notifyOnExtremeHeat" type="checkbox">
                                    <span>熱中症の時に通知</span>
                                </label>
                            </div>
                        </div>
                        <div class="settings-section">
                            <h3>アプリについて</h3>
                            <p>Glass Weather v1.0.0</p>
                            <p>Liquid Glass デザインの天気アプリ</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    `,

    setup() {
        // Services
        const weatherService = new WeatherService();
        const storageService = new StorageService();
        const notificationsService = new NotificationsService();

        // State
        const weather = ref(null);
        const forecast = ref([]);
        const currentLocation = ref('現在地を取得中...');
        const isLoading = ref(true);
        const errorMessage = ref('');
        const favorites = ref([]);
        const showFavoritesModal = ref(false);
        const showSettingsModal = ref(false);
        const searchCity = ref('');
        const searchResults = ref([]);
        const notificationSettings = ref(storageService.getNotificationSettings());
        const isDaytime = ref(true);

        // Computed
        const backgroundGradient = computed(() => {
            if (!weather.value) {
                return 'linear-gradient(135deg, #1e3a8a 0%, #1e40af 50%, #0c4a6e 100%)';
            }

            const condition = weather.value.condition.toLowerCase();

            if (condition.includes('rain') || condition.includes('drizzle')) {
                return 'linear-gradient(135deg, #334155 0%, #475569 50%, #1e293b 100%)';
            } else if (condition.includes('thunder') || condition.includes('storm')) {
                return 'linear-gradient(135deg, #1a202c 0%, #2d3748 50%, #0f172a 100%)';
            } else if (condition.includes('snow')) {
                return 'linear-gradient(135deg, #cbd5e1 0%, #94a3b8 50%, #64748b 100%)';
            } else if (condition.includes('cloud')) {
                return 'linear-gradient(135deg, #3b82f6 0%, #1e40af 50%, #172554 100%)';
            } else if (isDaytime.value) {
                return 'linear-gradient(135deg, #3b82f6 0%, #1e40af 50%, #0c4a6e 100%)';
            } else {
                return 'linear-gradient(135deg, #1e293b 0%, #0f172a 50%, #000814 100%)';
            }
        });

        const showRain = computed(() => {
            return weather.value && (weather.value.condition.toLowerCase().includes('rain') || weather.value.condition.toLowerCase().includes('drizzle'));
        });

        const showSnow = computed(() => {
            return weather.value && weather.value.condition.toLowerCase().includes('snow');
        });

        const showThunder = computed(() => {
            return weather.value && (weather.value.condition.toLowerCase().includes('thunder') || weather.value.condition.toLowerCase().includes('storm'));
        });

        const showClouds = computed(() => {
            return weather.value && weather.value.condition.toLowerCase().includes('cloud');
        });

        // Methods
        const getWeatherEmoji = (condition = null) => {
            const cond = (condition || weather.value?.condition || '').toLowerCase();
            
            if (cond.includes('clear') || cond.includes('sunny')) return '☀️';
            if (cond.includes('cloud')) return '☁️';
            if (cond.includes('rain') || cond.includes('drizzle')) return '🌧️';
            if (cond.includes('thunder') || cond.includes('storm')) return '⛈️';
            if (cond.includes('snow')) return '❄️';
            if (cond.includes('mist') || cond.includes('fog')) return '🌫️';
            if (cond.includes('wind')) return '💨';
            return '🌤️';
        };

        const formatTime = (timestamp) => {
            const date = new Date(timestamp * 1000);
            return date.toLocaleTimeString('ja-JP', { hour: '2-digit', minute: '2-digit' });
        };

        const formatDate = (dateString) => {
            const date = new Date(dateString);
            return date.toLocaleDateString('ja-JP', { month: 'short', day: 'numeric' });
        };

        const randomRainPosition = () => {
            return {
                left: Math.random() * 100 + '%',
                top: Math.random() * -100 + '%',
                animationDuration: (Math.random() * 0.5 + 0.3) + 's',
                animationDelay: Math.random() * 2 + 's'
            };
        };

        const randomSnowPosition = () => {
            return {
                left: Math.random() * 100 + '%',
                top: Math.random() * -100 + '%',
                width: (Math.random() * 8 + 4) + 'px',
                height: (Math.random() * 8 + 4) + 'px',
                animationDuration: (Math.random() * 4 + 6) + 's',
                animationDelay: Math.random() * 2 + 's'
            };
        };

        const getCurrentLocation = () => {
            if ('geolocation' in navigator) {
                navigator.geolocation.getCurrentPosition(
                    position => {
                        const { latitude, longitude } = position.coords;
                        fetchWeather(latitude, longitude);
                    },
                    error => {
                        console.log('位置情報取得エラー:', error);
                        errorMessage.value = '位置情報を取得できませんでした';
                        isLoading.value = false;
                    }
                );
            } else {
                errorMessage.value = 'このブラウザは位置情報をサポートしていません';
                isLoading.value = false;
            }
        };

        const fetchWeather = async (latitude, longitude) => {
            try {
                isLoading.value = true;
                errorMessage.value = '';

                const currentData = await weatherService.getCurrentWeather(latitude, longitude);
                weather.value = weatherService.convertWeatherData(currentData);
                currentLocation.value = `${currentData.name}, ${currentData.sys.country}`;
                storageService.setLastLocation({ name: currentData.name, lat: latitude, lon: longitude });

                // Check daytime
                const now = Date.now() / 1000;
                isDaytime.value = now > weather.value.sunrise && now < weather.value.sunset;

                // Fetch forecast
                const forecastData = await weatherService.getForecast(latitude, longitude);
                parseForecast(forecastData);

                // Send notification if needed
                notificationsService.sendWeatherAlert(weather.value);

            } catch (error) {
                errorMessage.value = error.message;
            } finally {
                isLoading.value = false;
            }
        };

        const parseForecast = (data) => {
            const dailyData = {};
            
            data.list.forEach(item => {
                const date = new Date(item.dt * 1000).toLocaleDateString();
                if (!dailyData[date]) {
                    dailyData[date] = {
                        date: date,
                        temps: [],
                        condition: item.weather[0].main,
                        precipitation: item.pop * 100
                    };
                }
                dailyData[date].temps.push(item.main.temp);
            });

            forecast.value = Object.values(dailyData).slice(0, 5).map(day => ({
                date: day.date,
                tempMax: Math.max(...day.temps),
                tempMin: Math.min(...day.temps),
                condition: day.condition,
                precipitation: day.precipitation
            }));
        };

        const refreshWeather = () => {
            const lastLocation = storageService.getLastLocation();
            if (lastLocation) {
                fetchWeather(lastLocation.lat, lastLocation.lon);
            } else {
                getCurrentLocation();
            }
        };

        const toggleFavorites = () => {
            showFavoritesModal.value = !showFavoritesModal.value;
        };

        const toggleSettings = () => {
            showSettingsModal.value = !showSettingsModal.value;
        };

        const selectFavorite = (city) => {
            fetchWeather(city.latitude, city.longitude);
            toggleFavorites();
        };

        const addFavorite = (city) => {
            const favorite = {
                id: Date.now(),
                name: city.name || currentLocation.value,
                country: city.country || '',
                latitude: city.latitude || weather.value?.lat,
                longitude: city.longitude || weather.value?.lon
            };
            storageService.addFavorite(favorite);
            favorites.value = storageService.getFavorites();
            searchCity.value = '';
            searchResults.value = [];
        };

        const removeFavorite = (id) => {
            storageService.removeFavorite(id);
            favorites.value = storageService.getFavorites();
        };

        watch(() => notificationSettings.value, (newSettings) => {
            storageService.setNotificationSettings(newSettings);
        }, { deep: true });

        onMounted(() => {
            notificationsService.requestPermission();
            favorites.value = storageService.getFavorites();
            getCurrentLocation();
        });

        return {
            weather,
            forecast,
            currentLocation,
            isLoading,
            errorMessage,
            favorites,
            showFavoritesModal,
            showSettingsModal,
            searchCity,
            searchResults,
            notificationSettings,
            backgroundGradient,
            showRain,
            showSnow,
            showThunder,
            showClouds,
            getWeatherEmoji,
            formatTime,
            formatDate,
            randomRainPosition,
            randomSnowPosition,
            refreshWeather,
            toggleFavorites,
            toggleSettings,
            selectFavorite,
            addFavorite,
            removeFavorite
        };
    }
});

app.mount('#app');
