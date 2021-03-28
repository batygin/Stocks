import Foundation

struct JSONStructure: Codable {
    let start: Int
    let count: Int
    let total: Int
    let description: String
    let quotes: [Quotes]
}

struct Quotes: Codable {
    let id = UUID()
    let name: String
    let corp: String
    let price: Double
    let trend: Double
    var favorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case name = "symbol"
        case corp = "shortName"
        case price = "regularMarketPrice"
        case trend = "regularMarketChange"
    }
}
