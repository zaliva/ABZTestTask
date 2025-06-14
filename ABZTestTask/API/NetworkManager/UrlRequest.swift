import Foundation

//Use all endpoints
enum UrlRequest: String {

    case token = "/api/v1/token"
    case users = "/api/v1/users"
    case positions = "/api/v1/positions"
    
    var fullUrl: String { "\(baseUrl)\(rawValue)" }
}
