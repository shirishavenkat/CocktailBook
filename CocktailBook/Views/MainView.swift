import SwiftUI

struct MainView: View {
    @StateObject private var viewModel = MainViewModel(service: CocktailService())
    
    var body: some View {
        NavigationView {
            VStack {
                
                
                if viewModel.isLoading {
                    if #available(iOS 14, *) {
                            ProgressView("Loading Cocktails...")
                                .padding()
                                .foregroundColor(.gray)
                        } else {
                            ActivityIndicator(isAnimating: .constant(true))
                                                    .frame(width: 50, height: 50)                        }
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 20) {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                        
                        Button(action: {
                            viewModel.retryFetchCocktails()
                        }) {
                            Text("Retry")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                } else {
                    // Filter picker for categories
                    Picker("Filter", selection: $viewModel.filterState) {
                        Text("All").tag(MainViewModel.FilterState.all)
                        Text("Alcoholic").tag(MainViewModel.FilterState.alcoholic)
                        Text("Non-Alcoholic").tag(MainViewModel.FilterState.nonAlcoholic)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    
                    // List of cocktails with NavigationLink
                    List(viewModel.filteredCocktails()) { cocktail in
                        NavigationLink(destination: DetailView(cocktail: cocktail, viewModel: viewModel)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(cocktail.name)
                                        .font(.headline)
                                        .foregroundColor(cocktail.isFavorite ? .blue : .primary)
                                    Text(cocktail.shortDescription)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(action: {
                                    viewModel.toggleFavorite(for: cocktail)
                                }) {
                                    if(cocktail.isFavorite){
                                        Image(systemName: cocktail.isFavorite ? "heart.fill" : "heart")
                                            .foregroundColor(cocktail.isFavorite ? .red : .gray)
                                    }
                                    
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                        }
                        
                    }
                    
                    .listStyle(PlainListStyle())
                }
            }
            .navigationBarTitle("Cocktails")
            .onAppear {
                viewModel.fetchCocktails()
            }
        }
    }
}
