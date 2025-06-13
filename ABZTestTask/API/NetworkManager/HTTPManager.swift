import Foundation
import SwiftyJSON
import Alamofire

typealias SuccessHandler = (JSON) -> Void
typealias FailureHandler = (ApiError) -> Void

class HTTPManager {

    //MARK: - GET
    class func get(url: UrlRequest, params: [String: Any]?, successHandler: SuccessHandler? = nil, failureHandler: FailureHandler? = nil) {
        
        var requestUrl = url.fullUrl
        
        if let params = params {
            requestUrl += convertDictParamsToStringUrl(params)
        }

        NetworkSessionManager.shared
            .sessionManager
            .request(requestUrl,
                     method: .get,
                     encoding: JSONEncoding.default,
                     headers: API.authorizedHeaders())
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                        handleSuccessResponse(url: requestUrl, data: data, successHandler: successHandler, failureHandler: failureHandler)
                case .failure(let error):
                    handleFailureResponse(response: response, responseError: error, failureHandler: failureHandler)
                }
            }
    }

    //MARK: - POST
    class func post(url: UrlRequest, params: [String: Any]?, successHandler: SuccessHandler? = nil, failureHandler: FailureHandler? = nil) {
        NetworkSessionManager.shared
            .sessionManager
            .request(url.fullUrl,
                     method: .post,
                     parameters: params,
                     encoding: JSONEncoding.default,
                     headers: API.authorizedHeaders())
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    handleSuccessResponse(url: url.fullUrl, data: data, successHandler: successHandler, failureHandler: failureHandler)
                case .failure(let error):
                    handleFailureResponse(response: response, responseError: error, failureHandler: failureHandler)
                }
            }
    }
    
    //MARK: - Failure
    private class func handleFailureData(data: Data, failureHandler: FailureHandler?, defaultError: ApiError? = nil) {
        let defaultError: ApiError = defaultError != nil ? defaultError! : ApiError(title: LocalizeStrings.networkError, displayMessage: LocalizeStrings.networkErrorMsg, errorCode: ErrorCode.unknownСodeFromServer)
        do {
            let resultModel = try JSONDecoder().decode(ErrorResponse.self, from: data)
            
            var displayMessage = resultModel.message

            if let fails = resultModel.fails {
                let allMessages = fails.flatMap { $0.value }
                if !allMessages.isEmpty {
                    displayMessage = allMessages.joined(separator: "\n")
                }
            }

            failureHandler?(ApiError(
                title: LocalizeStrings.networkError,
                displayMessage: displayMessage,
                errorCode: ErrorCode.unknownСodeFromServer
            ))
        } catch {
            failureHandler?(defaultError)
        }
    }

    private class func handleFailureResponse(response: AFDataResponse<Data>, responseError: AFError, failureHandler: FailureHandler?) {
        let defaultError = ApiError(title: LocalizeStrings.networkError, displayMessage: responseError.localizedDescription, errorCode: responseError.responseCode ?? ErrorCode.unknownСodeFromServer)
        guard let data = response.data else {
            failureHandler?(defaultError)
            return
        }
        handleFailureData(data: data, failureHandler: failureHandler, defaultError: defaultError)
    }
    
    //MARK: - Success
    private class func handleSuccessResponse(url: String, data: Data, successHandler: SuccessHandler? = nil, failureHandler: FailureHandler? = nil) {
        do {
            let json = try JSON(data: data, options: [])
            let isSuccess = json["success"].boolValue
            if isSuccess {
                successHandler?(json)
            } else {
                handleFailureData(data: data, failureHandler: failureHandler)
            }
        } catch {
            failureHandler?(ApiError(title: LocalizeStrings.networkError, displayMessage: LocalizeStrings.networkErrorMsg, errorCode: ErrorCode.errorParsing))
        }
    }

    //MARK: - POST - Multipart Upload
    class func uploadMultipart(url: UrlRequest,
                               token: String,
                               parameters: [String: Any]?,
                               fileData: Data?,
                               fileFieldName: String = "file",
                               fileName: String = "file.jpg",
                               mimeType: String = "image/jpeg",
                               successHandler: SuccessHandler? = nil,
                               failureHandler: FailureHandler? = nil) {
        let headers: HTTPHeaders = ["Token": token]
        NetworkSessionManager.shared
            .sessionManager
            .upload(multipartFormData: { multipartFormData in
                if let parameters = parameters {
                    for (key, value) in parameters {
                        if let stringValue = "\(value)".data(using: .utf8) {
                            multipartFormData.append(stringValue, withName: key)
                        }
                    }
                }
                
                if let data = fileData {
                    multipartFormData.append(data, withName: fileFieldName, fileName: fileName, mimeType: mimeType)
                }
            }, to: url.fullUrl,
            method: .post,
            headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    handleSuccessResponse(url: url.fullUrl, data: data, successHandler: successHandler, failureHandler: failureHandler)
                case .failure(let error):
                    handleFailureResponse(response: response, responseError: error, failureHandler: failureHandler)
                }
            }
    }

    private class func convertDictParamsToStringUrl(_ params: [String: Any]) -> String {
        var stringUrl = String()
        for (key, value) in params {
            if stringUrl.contains("?") {
                stringUrl += "&\(key)=\(value)"
            } else {
                stringUrl += "?\(key)=\(value)"
            }
        }
        return stringUrl
    }
}
