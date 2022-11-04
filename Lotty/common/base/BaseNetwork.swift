import Foundation
import Alamofire
import RxSwift

class BaseNetwork: NSObject {
    
    func request<T: Codable>(
        api: APIBase,
        param: APIRequest? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        responseType: T.Type,
        success: ((T?) -> Void)?,
        failure: ((APIErrorResponse) -> Void)?
    ) {
        AF.request(api.getUrl(),
                   method: api.method,
                   parameters: param?.toDictionary(),
                   encoding: encoding,
                   headers: api.header,
                   interceptor: Interceptor.shared
        ).validate(statusCode: 200..<300)
            .responseDecodable(of: responseType) { response in
                switch response.result {
                    
                case .success(let data):
                    print("""
                        [Request \(param?.toDictionary())]
                        [Response \(api.url) \(Date())]
                        Param : \(String(describing: data.toDictionary()))
                        """)
                    DispatchQueue.main.async {
                        success?(data)
                    }
//                    if let jsonObject = data as? [String: Any] {
//                        print("""
//                            [Response \(api.url) \(Date())]
//                            Param : \(String(describing: jsonObject))
//                            """)
//                        DispatchQueue.global(qos: .background).async {
//                            do {
//                                let responseData = try JSONSerialization.data(withJSONObject: jsonObject, options: .fragmentsAllowed)
//                                let responseObject = try JSONDecoder().decode(responseType, from: responseData)
//                                DispatchQueue.main.async {
//                                    success?(responseObject)
//                                }
//                            } catch {
//                                print("JSON 직렬화 실패1", api.url, jsonObject)
//                            }
//                        }
//                    } else if let jsonObject = data as? [Any] {
//                        //key가 없는 리스트인 경우 무조건 파라미터는 : results라는 이름으로 정의
//                        print("""
//                            [Response(no key) \(api.url) \(Date())]
//                            Result : \(String(describing: jsonObject))
//                            """)
//                        let dic: [String:Any] = ["results" : jsonObject]
//                        DispatchQueue.global(qos: .background).async {
//                            do {
//                                let responseData = try JSONSerialization.data(withJSONObject: dic, options: .fragmentsAllowed)
//                                let responseObject = try JSONDecoder().decode(responseType, from: responseData)
//                                DispatchQueue.main.async {
//                                    success?(responseObject)
//                                }
//                            } catch {
//                                print("JSON 직렬화 실패2", api.url, jsonObject)
//                            }
//                        }
//                    }
                    
                case .failure(let error):
                    print("""
                        [Response \(api.url) \(Date())]
                        Error Code: \(error.responseCode ?? -1)
                        Error Description: \(error.localizedDescription))
                        """)

                    let apiError = APIErrorResponse()
                    apiError.code = "\(error.responseCode ?? -1)"
                    apiError.detail = error.localizedDescription

                    failure?(apiError)
                }
            }
    }
    
}
