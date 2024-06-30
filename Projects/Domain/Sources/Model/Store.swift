//
//  Store.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import Foundation

public struct Store {
    public let id: String
    public let storeName: String
    public let address: String
    public let roadAddress: String
    public let phone: String
    public let x: String
    public let y: String
    public let distance: String
    
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
