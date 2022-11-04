import Foundation
import Alamofire

class Interceptor: RequestInterceptor {

    static let shared = Interceptor()
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        completion(.success(urlRequest))
    }
    
}
