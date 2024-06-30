//
//  HistoryRepository.swift
//  Domain
//
//  Created by 유지호 on 6/27/24.
//  Copyright © 2024 jiho. All rights reserved.
//

import Foundation

public protocol HistoryRepository {
    func select(keyword: String, type: HistoryType)
//    func save(keyword: String, type: HistoryType)
//    func update(history: HistoryRO, type: HistoryType)
    func load(type: HistoryType) -> [History]
    func delete(keyword: String, type: HistoryType)
    func clear(type: HistoryType)
}
