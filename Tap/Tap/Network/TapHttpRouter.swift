import UIKit
import Foundation
import Alamofire
import ObjectMapper

public enum TapHttpRouter: URLRequestConvertible {

    case postCreditWallet(walletId: String,currency: String,amount: String,source: [String : Any])
    case postDebitWallet(walletId: String,currency: String,amount: String,source: [String : Any],destinationId: String)
    case getUserInfo(walletId: String)
   
    var method: Alamofire.HTTPMethod {
        switch self {
        case .postCreditWallet,
             .postDebitWallet:
            return.post
        case.getUserInfo:
            return.get
        }
    }
    
    var path: String {
        switch self {
        case.getUserInfo(let walletId):
            return walletId
        case.postCreditWallet:
            return "credits"
        case.postDebitWallet:
            return "debits"
            
       }
    }

    var useBaseUrl: Bool? {
        switch self {
        default:
            return true
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
            
        case.postCreditWallet(let walletId,let currency,let amount,let source):
            return ["id" :walletId,"currency" :currency,"amount" :amount,"source" :source]
        case.postDebitWallet(let walletId,let currency,let amount,let source,let destinationId):
            return ["id" :walletId,"currency" :currency,"amount" :amount,"source" :source,"destination_id":destinationId]
       
        case .getUserInfo( _):
            return [:]
        }
    }
    
    var urlParameters: [String: Any]? {
        switch self {
            
        default:
            return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = NSURL(string: Configuration.baseURL() + self.path)!
        var urlRequest = URLRequest(url: url as URL)
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "accept")
       urlRequest.setValue("Bearer sk_test_XKokBfNWv6FIYuTMg5sLPjhJ", forHTTPHeaderField: "Authorization")
     
        switch self {
        case .getUserInfo:
            return try URLEncoding.queryString.encode(urlRequest, with: self.parameters)
        case .postCreditWallet,
             .postDebitWallet:
            return try JSONEncoding.default.encode(urlRequest, with: self.parameters)
            
        }
    }
}


