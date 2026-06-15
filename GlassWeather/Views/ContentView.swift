import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var showFavorites = false
    @State private var showSettings = false
    @State private var isRefreshing = false
    
    var body: some View {
        ZStack {
            // Dynamic background based on weather
            BackgroundView(
                isDaytime: viewModel.isDaytime,
                weatherCondition: viewModel.currentWeather?.condition ?? ""
            )
            .ignoresSafeArea()
            
            // Weather animations overlay
            if let weather = viewModel.currentWeather {
                WeatherAnimationView(condition: weather.condition)
                    .ignoresSafeArea()
                    .pointer(.none)
            }
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Glass Weather")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(viewModel.locationName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: { showFavorites = true }) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        
                        Button(action: { showSettings = true }) {
                            Image(systemName: "gear")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                    }
                }
                .padding(20)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Current Weather Card
                        if let weather = viewModel.currentWeather {
                            MainWeatherView(weather: weather)
                        } else if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                                .padding(40)
                        }
                        
                        // Weather Details
                        if let weather = viewModel.currentWeather {
                            WeatherDetailView(weather: weather)
                        }
                        
                        // 5-Day Forecast
                        if !viewModel.dailyForecasts.isEmpty {
                            ForecastView()
                        }
                        
                        // Error message
                        if let error = viewModel.errorMessage {
                            HStack {
                                Image(systemName: "exclamationmark.circle.fill")
                                Text(error)
                            }
                            .foregroundColor(.red)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(12)
                            .padding(.horizontal)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                }
                .refreshable {
                    await viewModel.refreshWeather()
                }
                
                Spacer()
            }
        }
        .sheet(isPresented: $showFavorites) {
            FavoriteCitiesView()
                .environmentObject(viewModel)
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .onAppear {
            viewModel.requestLocationPermission()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WeatherViewModel())
}
