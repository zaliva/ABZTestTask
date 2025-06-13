import Foundation
import Alamofire

class NetworkSessionManager {

    static let shared = NetworkSessionManager()
    var sessionManager: Session

    private init() {
        let configuration = URLSessionConfiguration.default
        var headers = HTTPHeaders.default
        headers["Content-Type"] = "application/json"
        configuration.headers = headers
        configuration.timeoutIntervalForRequest = 60.0
        self.sessionManager = Session(configuration: configuration, interceptor: JWTAccessTokenInterceptor())
    }
}

final class JWTAccessTokenInterceptor: RequestInterceptor {
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == ErrorCode.unauthorized else {
            if let response = request.task?.response as? HTTPURLResponse {
                debugPrint("response.statusCode", response.statusCode)
            }
            completion(.doNotRetry)
            return
        }
        completion(.doNotRetry)
    }
}

class API {
    static func authorizedHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "content-type": "application/json"
        ]
        return headers
    }
}

struct ApiError: Codable {
    let title: String
    let displayMessage: String
    let errorCode: Int
    
    init(title: String, displayMessage: String, errorCode: Int) {
        self.title = title
        self.displayMessage = displayMessage
        self.errorCode = errorCode
    }
}

enum ErrorCode {
    static let unauthorized = 401
    static let errorParsing = 5001
    static let errorEncoding = 5002
    static let errorDecode = 5003
    static let errorGuard = 5004
    static let errorDecrypt = 5005
    static let unknownСodeFromServer = 5006
}
