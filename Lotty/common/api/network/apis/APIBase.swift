import Alamofire

// MARK: - Request
protocol APIRequest: Codable { }


// MARK: - Response
protocol APIResponse: Codable { }

class APIErrorResponse: Codable {
    var code: String?
    var message: String?
    var detail: String?
}


// MARK: - API Template
class APIBase: NSObject {
    var url = ""
    var method: HTTPMethod = .get
    var header: HTTPHeaders = .default
    var pathValue: [String: String]?
}


extension APIBase {
    
    func getUrl() -> URL {
        pathValue?.forEach{ [weak self] (item) in
            if let escapedString = item.value.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                self?.replaceVariablePath(varKey: item.key, value: escapedString)
            }
        }
        return URL(string: url)!
    }
    
    private func replaceVariablePath(varKey: String, value: String) {
        url = url.replacingOccurrences(of: "{\(varKey)}", with: value)
    }
    
}
