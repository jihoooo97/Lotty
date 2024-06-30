//
//  HistoryRO.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/17.
//

import Foundation
import RealmSwift
import Domain

public class HistoryRO: Object, Codable {
    @Persisted var keyword: String
    @Persisted var type: ROType
    @Persisted var date: Date
    
    func toEntity() -> History {
        return .init(
            keyword: self.keyword,
            date: self.date
        )
    }
}
