
import UIKit
import Foundation
import ObjectMapper
import BrightFutures
import Alamofire
import AlamofireObjectMapper
import RappleProgressHUD

public enum NetworkError: Error {
    case notFound
    case unauthorized
    case forbidden
    case conflict
    case nonRecoverable
    case unprocessableEntity(String?)
    case appProcessableEntity(String?)
    case other
}

typealias CompletionBlock = (_ success: Bool, _ response: Any?) -> Void

class NetworkManager {
    
    public static let networkQueue = DispatchQueue(label: "\(String(describing: Bundle.main.bundleIdentifier)).networking-queue", attributes: .concurrent)
    
    public static func makeRequest<T: Mappable>(_ urlRequest: URLRequestConvertible,showProgress: Bool? = true) -> Future<T, NetworkError> {
        let promise = Promise<T, NetworkError>()
        if (showProgress == true) {
            let attributes = RappleActivityIndicatorView.attribute(style: RappleStyle.apple)
            RappleActivityIndicatorView.startAnimating(attributes: attributes)
        }
        
        let request = Alamofire.request(urlRequest)
            .validate()
            .responseObject(queue: networkQueue) { (response: DataResponse<T>)-> Void in
                print("\nResponse: \(NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!)\n")
                
                if (showProgress == true) {
                    DispatchQueue.main.async() {
                        RappleActivityIndicatorView.stopAnimation()
                    }
                }
               
                switch response.result {
                case .success:
                    promise.success(response.result.value!)
                case .failure
                    where response.response?.statusCode == 401:
                    promise.failure(.unauthorized)
                case .failure
                    where response.response?.statusCode == 403:
                    promise.failure(.forbidden)
                case .failure
                    where response.response?.statusCode == 404:
                    promise.failure(.notFound)
                case .failure
                    where response.response?.statusCode == 422:
                    var jsonData: String?
                    if let data = response.data {
                        jsonData = String(data: data, encoding: .utf8)
                    }
                    promise.failure(.unprocessableEntity(jsonData))
                case .failure
                    where response.response?.statusCode == 500:
                    promise.failure(.nonRecoverable)
                case .failure:
                    promise.failure(.other)
                }
        }
        
        print("\nRequest: ")
        debugPrint(request)
        print("\n")
        
        return promise.future
    }
}

enum Result {
    case success(Any)
    case failure(String)
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var isFailure: Bool {
        return !isSuccess
    }
    
    var value: Any? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    var error: String? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
