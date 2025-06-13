
import Foundation

struct UsersResponse: Codable {
    let success: Bool
    let page: Int
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let users: [UserModel]
    enum CodingKeys: String, CodingKey {
        case success, page, count, users
        case totalPages = "total_pages"
        case totalUsers = "total_users"
    }
}

struct PaginationLinks: Codable {
    let nextUrl: String?
    let prevUrl: String?
}

struct UserModel: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let positionId: Int
    let photo: String

    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, position, photo
        case positionId = "position_id"
    }
}

struct UserParams: Decodable {
    let name: String
    let email: String
    let phone: String
    let positionId: Int
    let photo: String

    enum CodingKeys: String, CodingKey {
        case name, email, phone, photo
        case positionId = "position_id"
    }
}

struct UsersRegisterResponse: Codable {
    let success: Bool
    let userId: Int
    let message: String

    enum CodingKeys: String, CodingKey {
        case success, message
        case userId = "user_id"
    }
}

struct ErrorResponse: Codable {
    let success: Bool
    let message: String
    let fails: [String: [String]]?
}
