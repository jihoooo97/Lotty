import Foundation

extension Encodable {

    func toJSON() -> String? {
        if let data = try? JSONEncoder().encode(self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }

    func toDictionary() -> [String: Any]? {
        if let data = try? JSONEncoder().encode(self) {
            do {
                let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                return dict?.filter{ ($0.value as? NSNull) == nil}
            } catch {
                print("Dict화 실패",error.localizedDescription)
            }
        }
        return nil
    }
    
    func toApiEntity<T: Codable>(_ apiType: T.Type) -> T? {
        if let data = try? JSONEncoder().encode(self) {
            if let apiEntity = try? JSONDecoder().decode(T.self, from: data){
                return apiEntity
            }
        }
        
        return nil
    }
    
    func toViewEntity<T: Codable>(_ entityType: T.Type) -> T? {
        if let data = try? JSONEncoder().encode(self),
           let viewEntity = try? JSONDecoder().decode(T.self, from: data) {
            return viewEntity
        }
        
        return nil
    }
    
}

extension Decodable {
    
    static func getInstance(dictionary: [String: Any]) -> Self? {
        if let jsonData = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted) {
            return try? JSONDecoder().decode(Self.self, from: jsonData)
        }
        return nil
    }
    
}
