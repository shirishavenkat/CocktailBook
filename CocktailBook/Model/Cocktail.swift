struct Cocktail: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let shortDescription: String
    let longDescription: String
    let preparationMinutes: Int
    let imageName: String
    let ingredients: [String]
    
    var isAlcoholic: Bool {
        return type.lowercased() == "alcoholic"
    }
    
    var isFavorite: Bool = false

    private enum CodingKeys: String, CodingKey {
        case id, name, type, shortDescription, longDescription, preparationMinutes, imageName, ingredients
    }
}
