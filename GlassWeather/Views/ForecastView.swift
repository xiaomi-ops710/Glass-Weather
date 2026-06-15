import SwiftUI

struct ForecastView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("5日間予報")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal, 24)
            
            if viewModel.isLoadingForecast {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else if !viewModel.dailyForecasts.isEmpty {
                VStack(spacing: 12) {
                    ForEach(viewModel.dailyForecasts.prefix(5)) { forecast in
                        ForecastRow(forecast: forecast)
                    }
                }
                .padding(.horizontal, 24)
            }
        }
        .padding(.vertical, 20)
    }
}

struct ForecastRow: View {
    let forecast: DailyForecast
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(forecast.dayName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(forecast.dayDate)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                WeatherIcon(condition: forecast.condition)
                    .font(.system(size: 24))
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Text(String(format: "%.0f", forecast.tempMax))
                            .foregroundColor(.white)
                        Text("°").foregroundColor(.white)
                        Text(String(format: "%.0f", forecast.tempMin))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .font(.system(size: 14, weight: .semibold))
                    
                    Text("\(Int(forecast.precipitationProbability))% 降水")
                        .font(.system(size: 11, weight: .regular))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .padding(12)
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview {
    ForecastView()
        .environmentObject(WeatherViewModel())
        .padding()
        .background(LinearGradient(
            gradient: Gradient(colors: [.blue.opacity(0.3), .cyan.opacity(0.2)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        ))
}
