//
//  StoreModel.swift
//  Domain
//
//  Created by 유지호 on 6/14/25.
//  Copyright © 2025 Lotty. All rights reserved.
//


public struct StoreModel: Hashable {
    public let id: String
    public let storeName: String
    public let address, roadAddress: String
    public let phone: String
    public let x, y, distance: String
    
    public init(
        id: String,
        storeName: String,
        address: String,
        roadAddress: String,
        phone: String,
        x: String,
        y: String,
        distance: String
    ) {
        self.id = id
        self.storeName = storeName
        self.address = address
        self.roadAddress = roadAddress
        self.phone = phone
        self.x = x
        self.y = y
        self.distance = distance
    }
}
