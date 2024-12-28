import Combine

protocol CocktailServiceProtocol {
    func fetchCocktails() -> AnyPublisher<[Cocktail], Error>
}
