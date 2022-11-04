import Foundation

struct StoreInfo: Codable {
    let documents: [Documents]
}

struct Documents: Codable {
    let id: String
    let place_name: String
    let address_name: String
    let road_address_name: String
    let phone: String
    let x: String
    let y: String
    // "distance": "2615",
    // "place_url": "http://place.map.kakao.com/2091279060",
}

struct Meta: Codable {
    // "is_end": false,
    // "pageable_count": 45,
    // "same_name": {
    //    "keyword": "복권 판매점",
    //    "region": [],
    //    "selected_region": ""
    //  },
    //  "total_count": 4760
}
