//
//  StoreDTO.swift
//  Domain
//
//  Created by 유지호 on 6/13/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import Domain

import Foundation

public struct StoreEntity: Decodable {
    public let documents: [Documents]
}

public struct Documents: Decodable {
    public let id: String
    public let name: String
    public let address: String
    public let roadAddress: String
    public let phone: String
    public let x, y: String
    public let distance: String
    public let placeUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id, phone, x, y, distance
        case name = "place_name"
        case address = "address_name"
        case roadAddress = "road_address_name"
        case placeUrl = "place_url"
    }
    
    public func toDomain() -> StoreModel {
        return .init(
            id: id,
            storeName: name,
            address: address,
            roadAddress: roadAddress,
            phone: phone,
            x: x,
            y: y,
            distance: distance
        )
    }
}
