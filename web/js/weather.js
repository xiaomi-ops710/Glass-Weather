// Weather Service
class WeatherService {
    constructor() {
        this.apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
        this.baseUrl = 'https://api.openweathermap.org/data/2.5';
    }

    async getCurrentWeather(lat, lon) {
        try {
            const response = await fetch(
                `${this.baseUrl}/weather?lat=${lat}&lon=${lon}&appid=${this.apiKey}&units=metric&lang=ja`
            );
            if (!response.ok) throw new Error('天気情報の取得に失敗しました');
            return await response.json();
        } catch (error) {
            throw new Error(`天気API エラー: ${error.message}`);
        }
    }

    async getForecast(lat, lon) {
        try {
            const response = await fetch(
                `${this.baseUrl}/forecast?lat=${lat}&lon=${lon}&appid=${this.apiKey}&units=metric&lang=ja`
            );
            if (!response.ok) throw new Error('予報情報の取得に失敗しました');
            return await response.json();
        } catch (error) {
            throw new Error(`予報API エラー: ${error.message}`);
        }
    }

    async getUVIndex(lat, lon) {
        try {
            const response = await fetch(
                `${this.baseUrl}/uvi?lat=${lat}&lon=${lon}&appid=${this.apiKey}`
            );
            if (!response.ok) throw new Error('UV指数の取得に失敗しました');
            return await response.json();
        } catch (error) {
            throw new Error(`UV API エラー: ${error.message}`);
        }
    }

    convertWeatherData(data) {
        return {
            temp: data.main.temp,
            feelsLike: data.main.feels_like,
            humidity: data.main.humidity,
            pressure: data.main.pressure,
            windSpeed: data.wind.speed,
            windDeg: data.wind.deg,
            visibility: data.visibility,
            condition: data.weather[0].main,
            description: data.weather[0].description,
            icon: data.weather[0].icon,
            clouds: data.clouds.all,
            sunset: data.sys.sunset,
            sunrise: data.sys.sunrise
        };
    }
}
