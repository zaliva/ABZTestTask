import Foundation
import SwiftyJSON

class NetworkManager {
    
    typealias SuccessModel<M: Codable> = (M) -> Void
    
    class func handleModel<M: Codable>(json: JSON, success: SuccessModel<M>? = nil, failure: FailureHandler? = nil) {
        guard let data = try? json.rawData() else {
            failure?(ApiError(title: LocalizeStrings.networkError, displayMessage: LocalizeStrings.networkErrorMsg, errorCode: ErrorCode.errorParsing))
            return
        }
        
        do {
            let resultModel = try JSONDecoder().decode(M.self, from: data)
            success?(resultModel)
        } catch let error {
            failure?(ApiError(title: LocalizeStrings.networkError, displayMessage: error.localizedDescription, errorCode: ErrorCode.errorDecode))
        }
    }
    
    class func handleArrayOfModels<M: Codable>(json: JSON, success: SuccessModel<[M]>? = nil, failure: FailureHandler? = nil) {
        guard let data = try? json.rawData() else {
            failure?(ApiError(title: LocalizeStrings.networkError, displayMessage: LocalizeStrings.networkErrorMsg, errorCode: ErrorCode.errorParsing))
            return
        }
        do {
            let resultModel = try JSONDecoder().decode([M].self, from: data)
            success?(resultModel)
        } catch {
            failure?(ApiError(title: LocalizeStrings.networkError, displayMessage: error.localizedDescription, errorCode: ErrorCode.errorDecode))
        }
    }
    
    //MARK: - GetToken
    class func getToken(success: ((String) -> Void)? = nil, failure: FailureHandler? = nil) {
        HTTPManager.post(url: .token, params: nil) { result in
            let token = result["token"].stringValue
            Persistance.token = token
            success?(token)
        } failureHandler: { error in
            failure?(error)
        }
    }
    
    // MARK: - User
    class func getUsers(page: Int, count: Int, success: ((UsersResponse) -> Void)? = nil, failure: FailureHandler? = nil) {
        let params: [String : Any] = ["page": page, "count": count]
        HTTPManager.get(url: .users, params: params) { result in
            handleModel(json: result, success: success, failure: failure)
        } failureHandler: { error in
            failure?(error)
        }
    }
    
    class func getPositions(success: ((PositionsResponse) -> Void)? = nil, failure: FailureHandler? = nil) {
        HTTPManager.get(url: .positions, params: nil) { result in
            handleModel(json: result, success: success, failure: failure)
        } failureHandler: { error in
            failure?(error)
        }
    }
    
    // MARK: - Register User
    class func registerUser(name: String, email: String, phone: String, positionId: Int, photo: Data, success: ((UsersRegisterResponse) -> Void)? = nil, failure: FailureHandler? = nil) {
        getToken() { token in
            let parameters: [String: Any] = [
                "name": name,
                "email": email,
                "phone": phone,
                "position_id": positionId
            ]
            
            HTTPManager.uploadMultipart(url: .users, token: token, parameters: parameters, fileData: photo, fileFieldName: "photo", fileName: "photo.jpg", mimeType: "image/jpeg") { result in
                handleModel(json: result, success: success, failure: failure)
            } failureHandler: { error in
                failure?(error)
            }
        }
        failure: { error in
            failure?(error)
        }
    }
}

