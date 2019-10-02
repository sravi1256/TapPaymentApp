
import UIKit
import ObjectMapper

class CreditWallet: Mappable {
    init() {
        
    }
    var walletId : String?
    var receiptID : String?
    var amount : String?
    var currency : String?
    var source : [String : Any]?
    
    var id : Int?
    var customer : Customers?
    var balance : Int?
    var transactions : [String]?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        customer <- map["customer"]
        currency <- map["currency"]
        balance <- map["balance"]
        transactions <- map["transactions"]
    }
}

class DebitsWallet: Mappable {
    init() {
        
    }
    var walletId : String?
    var receiptID : String?
    var amount : String?
    var currency : String?
    var destinationId: String?
    var source : [String : Any]?
    
    var id : Int?
    var customer : Customers?
    var balance : Int?
    var transactions : [String]?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        customer <- map["customer"]
        currency <- map["currency"]
        balance <- map["balance"]
        transactions <- map["transactions"]
    }
}
