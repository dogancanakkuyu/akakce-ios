import Foundation



struct Result: Codable {
    let nextURL: String?
    let horizontalProducts: [Product]?
    let products: [Product]

    enum CodingKeys: String, CodingKey {
        case nextURL = "nextUrl"
        case horizontalProducts, products
    }
    init(){
        nextURL = nil
        horizontalProducts = []
        products = []
    }
}

// MARK: - Product
struct Product: Codable {
    let code: Int
    let imageURL: String
    let name: String
    let dropRatio: Double?
    let price: Double
    let countOfPrices, followCount: Int?

    enum CodingKeys: String, CodingKey {
        case code
        case imageURL = "imageUrl"
        case name, dropRatio, price, countOfPrices, followCount
    }
}


struct Root: Codable {
    let result: Result
}
