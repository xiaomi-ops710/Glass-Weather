import SwiftUI

struct FavoriteCitiesView: View {
    @EnvironmentObject var viewModel: WeatherViewModel
    @State private var showAddCity = false
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(isDaytime: viewModel.isDaytime)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("お気に入り都市")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: { showAddCity = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(20)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            if viewModel.favoriteCities.isEmpty {
                                VStack(spacing: 16) {
                                    Image(systemName: "star.slash")
                                        .font(.system(size: 48))
                                        .foregroundColor(.white.opacity(0.5))
                                    
                                    Text("お気に入り都市がありません")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.7))
                                    
                                    Text("+ボタンから都市を追加できます")
                                        .font(.system(size: 14, weight: .regular))
                                        .foregroundColor(.white.opacity(0.5))
                                }
                                .frame(maxHeight: .infinity, alignment: .center)
                            } else {
                                ForEach(viewModel.favoriteCities) { city in
                                    FavoriteCityCard(city: city, viewModel: viewModel)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                }
            }
            .sheet(isPresented: $showAddCity) {
                AddCityView(viewModel: viewModel)
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct FavoriteCityCard: View {
    let city: FavoriteCity
    @EnvironmentObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(city.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(city.country)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Button(action: {
                    Task {
                        await viewModel.selectCity(city)
                    }
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            }
            
            Button(role: .destructive, action: {
                viewModel.removeFavorite(withId: city.id)
            }) {
                HStack {
                    Image(systemName: "trash.fill")
                    Text("削除")
                }
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .padding(16)
        .background(GlassStyle.glassBackground)
        .cornerRadius(16)
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(GlassStyle.glassBorder, lineWidth: 1.5))
    }
}

#Preview {
    FavoriteCitiesView()
        .environmentObject(WeatherViewModel())
}
