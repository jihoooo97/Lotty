import Foundation
import Alamofire

class APIAround: APIBase {

    override init() {
        super.init()
        
        url = "https://dapi.kakao.com/v2/local/search/keyword.json"
        method = .get
        header = [
            "Authorization": "KakaoAK 7165edf50ee98e1383adf5924f5a76ad"
        ]
    }
    
}


class AroundRequest: APIRequest {
    var x: Double? // longitude
    var y: Double? // latitude
    var query: String? = "복권 판매점"
    var size: Int?
}

class AroundResponse: APIResponse {
    let documents: [Documents]
}
