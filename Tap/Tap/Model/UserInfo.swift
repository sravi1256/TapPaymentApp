
import UIKit
import ObjectMapper
class UserInfo: Mappable {
    
    init() {
        
    }
    var walletId : String?
    var id : Int?
    var customer : Customers?
    var currency : String?
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


struct Customers : Mappable {
    var name : Name?
    var email : String?
    var phone : Phone?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        name <- map["name"]
        email <- map["email"]
        phone <- map["phone"]
    }
    
}

struct Name : Mappable {
    var title : String?
    var first : String?
    var last : String?
    var display : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        title <- map["title"]
        first <- map["first"]
        last <- map["last"]
        display <- map["display"]
    }
    
}

struct Phone : Mappable {
    var country_code : String?
    var number : String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        
        country_code <- map["country_code"]
        number <- map["number"]
    }
}
