import SwiftUI

struct AddCityView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: WeatherViewModel
    @State private var searchText = ""
    @State private var searchResults: [SearchResultCity] = []
    @State private var isSearching = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView(isDaytime: viewModel.isDaytime)
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    HStack {
                        Text("都市を追加")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(20)
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.white.opacity(0.7))
                        
                        TextField("都市を検索", text: $searchText)
                            .textFieldStyle(.plain)
                            .foregroundColor(.white)
                            .onChange(of: searchText) { _ in
                                Task {
                                    await performSearch()
                                }
                            }
                        
                        if !searchText.isEmpty {
                            Button(action: { searchText = "" }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                    }
                    .padding(12)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(12)
                    .padding(20)
                    
                    ScrollView {
                        VStack(spacing: 12) {
                            if isSearching {
                                ProgressView()
                                    .tint(.white)
                            } else if !searchResults.isEmpty {
                                ForEach(searchResults) { result in
                                    SearchResultRow(result: result, action: {
                                        viewModel.addFavorite(result)
                                        dismiss()
                                    })
                                }
                            } else if !searchText.isEmpty {
                                Text("検索結果が見つかりません")
                                    .foregroundColor(.white.opacity(0.5))
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
    
    private func performSearch() async {
        guard !searchText.isEmpty else {
            searchResults = []
            return
        }
        
        isSearching = true
        let service = CitySearchService()
        
        do {
            searchResults = try await service.searchCities(query: searchText)
        } catch {
            print("Search error: \(error)")
            searchResults = []
        }
        
        isSearching = false
    }
}

struct SearchResultRow: View {
    let result: SearchResultCity
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.city)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(result.country)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(12)
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)
        }
    }
}

#Preview {
    AddCityView(viewModel: WeatherViewModel())
}
