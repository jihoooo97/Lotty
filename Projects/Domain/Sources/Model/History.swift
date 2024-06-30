//
//  History.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/19.
//

import Foundation

public struct History: Codable {
    public var keyword: String
    public var date: Date
    
    public init(keyword: String, date: Date) {
        self.keyword = keyword
        self.date = date
    }
}
