import Alamofire

// MARK: - Request
protocol ApiRequest: Codable { }


// MARK: - Response
protocol ApiResponse: Codable { }

class ApiErrorResponse: Codable {
    var code: String?
    var message: String?
    var detail: String?
}


// MARK: - API Template
class ApiBase: NSObject {
    var url = ""
    var method: HTTPMethod = .get
    var header: HTTPHeaders = .default
    var pathValue: [String: String]?
}


extension ApiBase {
    
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
