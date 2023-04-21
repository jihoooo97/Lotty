//
//  StoreDTO.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import Foundation

struct StoreDTO: Decodable {
    let documents: [Documents]
}

struct Documents: Decodable {
    let id: String
    let name: String
    let address: String
    let roadAddress: String
    let phone: String
    let x: String
    let y: String
    let distance: String
    // "place_url": "http://place.map.kakao.com/2091279060",
    
    enum CodingKeys: String, CodingKey {
        case id, phone, x, y, distance
        case name = "place_name"
        case address = "address_name"
        case roadAddress = "road_address_name"
    }
}

struct Meta: Decodable {
    // "is_end": false,
    // "pageable_count": 45,
    // "same_name": {
    //    "keyword": "복권 판매점",
    //    "region": [],
    //    "selected_region": ""
    //  },
    //  "total_count": 4760
}


extension StoreDTO {

    func toDomain() -> [Store] {
        return documents.map { (store) -> Store in
            return .init(
                id: store.id,
                storeName: store.name,
                address: store.address,
                roadAddress: store.roadAddress,
                phone: store.phone,
                x: store.x,
                y: store.y,
                distance: store.distance
            )
        }
    }
    
}
