
import Foundation

struct PositionsResponse: Codable {
    let success: Bool
    let positions: [Position]
}

struct Position: Identifiable, Codable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}
