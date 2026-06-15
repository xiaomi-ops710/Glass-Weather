# Glass Weather 🌤️

A beautiful iOS weather application featuring Liquid Glass (Glassmorphism) design with SwiftUI.

## Features

- 🎨 **Liquid Glass Design** - Modern glassmorphism UI with frosted glass effects
- 🌡️ **Real-time Weather Data** - Current temperature, humidity, wind speed, and weather conditions
- 📍 **Location-based** - Automatic location detection using CoreLocation
- 🔄 **Pull-to-Refresh** - Update weather data on demand
- 📱 **Responsive Design** - Optimized for all iOS device sizes
- 🎯 **MVVM Architecture** - Clean and maintainable code structure
- 💾 **Local Caching** - Efficient data caching using UserDefaults

## Requirements

- iOS 15.0 or later
- Xcode 13.0 or later
- Swift 5.5 or later

## Installation

1. Clone the repository:
```bash
git clone https://github.com/xiaomi-ops710/Glass-Weather.git
cd Glass-Weather
```

2. Open the project in Xcode:
```bash
open GlassWeather.xcodeproj
```

3. Build and run the project on your simulator or device

## API Setup

This app uses OpenWeatherMap API. To use it:

1. Sign up at [OpenWeatherMap](https://openweathermap.org/api)
2. Get your free API key
3. Replace `YOUR_API_KEY` in `WeatherService.swift` with your actual API key

## Project Structure

```
GlassWeather/
├── App/
│   └── GlassWeatherApp.swift          # App entry point
├── Views/
│   ├── ContentView.swift              # Main view container
│   ├── MainWeatherView.swift          # Weather display
│   ├── WeatherDetailView.swift        # Detailed weather info
│   └── Components/
│       ├── GlassCard.swift            # Reusable glass card component
│       ├── WeatherIcon.swift          # Weather condition icons
│       └── BackgroundView.swift       # Dynamic gradient background
├── ViewModels/
│   └── WeatherViewModel.swift         # Weather data logic
├── Models/
│   ├── Weather.swift                  # Weather data model
│   ├── Location.swift                 # Location model
│   └── WeatherResponse.swift          # API response model
├── Services/
│   ├── WeatherService.swift           # API service for weather data
│   └── LocationService.swift          # Location tracking service
├── Styles/
│   └── GlassStyle.swift               # Glass effect modifiers
└── Resources/
    └── Assets.xcassets                # Images and colors
```

## Key Design Elements

### Liquid Glass Effect
- Semi-transparent background with blur effect
- Subtle gradient overlays
- Smooth animations and transitions
- Modern, minimalist aesthetic

### Color Palette
- Primary: Soft blue gradients
- Secondary: Glass white with transparency
- Accent: Weather-dependent dynamic colors

## Usage

1. Grant location permission when prompted
2. The app will automatically fetch weather data for your location
3. Pull down to refresh weather data
4. Tap on weather cards for detailed information

## Architecture

The app follows MVVM (Model-View-ViewModel) architecture:

- **Models**: Data structures representing weather and location
- **ViewModels**: Logic layer managing state and data fetching
- **Views**: SwiftUI views for UI presentation
- **Services**: API and location services
- **Styles**: Reusable UI modifiers and effects

## Dependencies

- SwiftUI (native)
- Combine (native)
- CoreLocation (native)
- URLSession (native)

## License

MIT License - feel free to use this project for personal or commercial purposes.

## Author

Created by xiaomi-ops710

---

**Enjoy the beautiful weather app! 🌈**
