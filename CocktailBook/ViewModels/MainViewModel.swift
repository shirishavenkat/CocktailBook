//
//  MainViewModel.swift
//  CocktailBook
//
//  Created by Venkat_test on 23/12/2024.
//

import Foundation
import Combine
import CocktailsAPI

class MainViewModel: ObservableObject {
    @Published var cocktails: [Cocktail] = []
    @Published var filterState: FilterState = .all
    @Published var errorMessage: String?
    @Published var favoriteCocktailIDs: Set<String> = []
    @Published var isLoading: Bool = false

     var service: CocktailServiceProtocol
        private var cancellables = Set<AnyCancellable>()
    var favoritesKey = "favoriteCocktailIDs" // Key for UserDefaults
    
    enum FilterState {
        case all, alcoholic, nonAlcoholic
    }
   

    init(service: CocktailServiceProtocol) {
            self.service = service // Default service
       
          loadFavorites()
          fetchCocktails()
      }
      
    
    func fetchCocktails(retryCount: Int = 3) {
        isLoading = true
              errorMessage = nil
            service.fetchCocktails()
            .retry(retryCount) // Retry up to `retryCount` times
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case let .failure(error) = completion {
                           if let cocktailsError = error as? CocktailsAPIError, cocktailsError == .unavailable {
                               self?.errorMessage = "The service is temporarily unavailable. Please try again."
                               self?.cocktails = []

                           } else {
                               self?.errorMessage = error.localizedDescription
                               self?.cocktails = []
                           }
                       }
                }, receiveValue: { [weak self] fetchedCocktails in
                    guard let self = self else { return }
                    self.cocktails = fetchedCocktails.map { cocktail in
                        var mutableCocktail = cocktail
                        mutableCocktail.isFavorite = self.favoriteCocktailIDs.contains(cocktail.id)
                        return mutableCocktail
                    }.sorted { $0.name < $1.name }
                })
                .store(in: &cancellables)
    }
    
    
    func retryFetchCocktails() {
        fetchCocktails()
    }
    
    func toggleFavorite(for cocktail: Cocktail) {
        if favoriteCocktailIDs.contains(cocktail.id) {
            favoriteCocktailIDs.remove(cocktail.id)
        } else {
            favoriteCocktailIDs.insert(cocktail.id)
        }
        saveFavorites()
        updateFavoriteStatus()
    }
    
    private func saveFavorites() {
        UserDefaults.standard.set(Array(favoriteCocktailIDs), forKey: favoritesKey)
    }
    
    func loadFavorites() {
        let savedIDs = UserDefaults.standard.array(forKey: favoritesKey) as? [String] ?? []
        favoriteCocktailIDs = Set(savedIDs)
        print("Loaded Favorites: \(favoriteCocktailIDs)")

    }
    
    private func updateFavoriteStatus() {
        cocktails = cocktails.map { cocktail in
            var mutableCocktail = cocktail
            mutableCocktail.isFavorite = favoriteCocktailIDs.contains(cocktail.id)
            return mutableCocktail
        }
    }
    
    func filteredCocktails() -> [Cocktail] {
        let filtered = filterState == .all ? cocktails :
            cocktails.filter { $0.isAlcoholic == (filterState == .alcoholic) }
        
        var vv = filtered.sorted {
            if $0.isFavorite != $1.isFavorite {
                return $0.isFavorite
            }
            return $0.name < $1.name
        }
        return vv
    }
    
    
}
