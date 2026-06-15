import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var isRefreshing = false
    
    var body: some View {
        ZStack {
            // Dynamic background based on weather
            BackgroundView(isDaytime: viewModel.isDaytime)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Glass Weather")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(viewModel.locationName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
        .onAppear {
            viewModel.requestLocationPermission()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(WeatherViewModel())
}
