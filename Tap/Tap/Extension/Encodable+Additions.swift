
import class Foundation.NSJSONSerialization.JSONEncoder
import class Foundation.NSJSONSerialization.JSONSerialization

internal extension Encodable {
    
    var dictionaryRepresentation: [String: Any]? {
        
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        let object = try? JSONSerialization.jsonObject(with: data, options: [])
        
        if let dictionaryObject = object as? [String: Any] {
            
            return dictionaryObject
        }
        else {
            
            return nil
        }
    }
}
