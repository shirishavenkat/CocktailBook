import XCTest
@testable import CocktailsAPI

final class CocktailsAPITests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let api: CocktailsAPI = FakeCocktailsAPI(withFailure: .count(3))
    }
}
