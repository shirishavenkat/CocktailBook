import Foundation
import Combine
import CocktailsAPI

class CocktailService: CocktailServiceProtocol {
    private let api: CocktailsAPI = FakeCocktailsAPI(withFailure: .count(3))

    
    func fetchCocktails() -> AnyPublisher<[Cocktail], Error> {
        return api.cocktailsPublisher
            .decode(type: [Cocktail].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}


