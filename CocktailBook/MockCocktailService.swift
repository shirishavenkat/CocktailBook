import Combine

class MockCocktailService: CocktailServiceProtocol {
    var result: Result<[Cocktail], Error> = .success([])

    func fetchCocktails() -> AnyPublisher<[Cocktail], Error> {
        return Future { promise in
            promise(self.result)
        }
        .eraseToAnyPublisher()
    }
}
