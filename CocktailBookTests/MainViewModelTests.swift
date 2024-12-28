import XCTest
import Combine
@testable import CocktailBook

class MainViewModelTests: XCTestCase {
    var viewModel: MainViewModel!
    var mockService: MockCocktailService!
    var cancellables: Set<AnyCancellable>!
    let testFavoritesKey = "testFavoriteCocktailIDs"

    override func setUp() {
        super.setUp()
        mockService = MockCocktailService()
        viewModel = MainViewModel(service: mockService)

        cancellables = []
        viewModel.favoritesKey = testFavoritesKey
        UserDefaults.standard.removeObject(forKey: testFavoritesKey)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        cancellables = nil
        UserDefaults.standard.removeObject(forKey: testFavoritesKey)

        super.tearDown()
    }

    func testFetchCocktailsSuccess() {
        let mockCocktails = [
            Cocktail(
                id: "1",
                name: "Mojito",
                type: "alcoholic",
                shortDescription: "Refreshing mint drink",
                longDescription: "A Cuban classic.",
                preparationMinutes: 5,
                imageName: "mojito",
                ingredients: ["Mint", "Rum"]
            ),
            Cocktail(
                id: "2",
                name: "Lemonade",
                type: "non-alcoholic",
                shortDescription: "Sweet and sour",
                longDescription: "A summer classic.",
                preparationMinutes: 3,
                imageName: "lemonade",
                ingredients: ["Lemon", "Sugar", "Water"]
            )
        ]
        mockService.result = .success(mockCocktails)

        let expectation = XCTestExpectation(description: "Fetch cocktails completes")
        viewModel.fetchCocktails()
        viewModel.$cocktails
            .dropFirst() // Skip the initial empty array
            .sink { cocktails in
                if !cocktails.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10.0)

        XCTAssertEqual(viewModel.cocktails.count, 2)
        XCTAssertEqual(viewModel.cocktails[1].name, "Mojito")
        XCTAssertEqual(viewModel.cocktails[0].name, "Lemonade")
    }

    func testFetchCocktailsFailure() {
        mockService.result = .failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Network Error"]))

        let expectation = XCTestExpectation(description: "Fetch cocktails failure completes")
        viewModel.fetchCocktails()
        viewModel.$errorMessage
            .dropFirst() // Wait for the update
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "Network Error")
                XCTAssertEqual(self.viewModel.cocktails.count, 0)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 10.0)
    }
    func testToggleFavorite() {
            let cocktail = Cocktail(id: "1", name: "Mojito", type: "alcoholic", shortDescription: "Refreshing mint drink", longDescription: "A Cuban classic.", preparationMinutes: 5, imageName: "mojito", ingredients: ["Mint", "Rum"])

            viewModel.toggleFavorite(for: cocktail)

            // Assert
            XCTAssertTrue(viewModel.favoriteCocktailIDs.contains(cocktail.id))
            XCTAssertTrue(viewModel.cocktails.first?.isFavorite ?? true)
        }
    func testFavoritesPersistence() {
           let cocktail = Cocktail(id: "1", name: "Mojito", type: "alcoholic", shortDescription: "Refreshing mint drink", longDescription: "A Cuban classic.", preparationMinutes: 5, imageName: "mojito", ingredients: ["Mint", "Rum"])
           viewModel.toggleFavorite(for: cocktail)

          
        viewModel.loadFavorites()

           XCTAssertTrue(viewModel.favoriteCocktailIDs.contains(cocktail.id))
       }

       func testFilterCocktails() {
           viewModel.cocktails = [
               Cocktail(id: "1", name: "Mojito", type: "alcoholic", shortDescription: "", longDescription: "", preparationMinutes: 5, imageName: "", ingredients: [], isFavorite: false),
               Cocktail(id: "2", name: "Lemonade", type: "non-alcoholic", shortDescription: "", longDescription: "", preparationMinutes: 3, imageName: "", ingredients: [], isFavorite: true)
           ]

           viewModel.filterState = .all
           XCTAssertEqual(viewModel.filteredCocktails().count, 2)

           viewModel.filterState = .alcoholic
           XCTAssertEqual(viewModel.filteredCocktails().count, 1)
           XCTAssertEqual(viewModel.filteredCocktails()[0].name, "Mojito")

           viewModel.filterState = .nonAlcoholic
           XCTAssertEqual(viewModel.filteredCocktails().count, 1)
           XCTAssertEqual(viewModel.filteredCocktails()[0].name, "Lemonade")
       }
}
