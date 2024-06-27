//
//  HistoryRepository.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import Foundation
import RealmSwift
import Domain

public enum ROType: String, Codable, PersistableEnum  {
    case map
    case lottery
}

public final class HistoryRepositoryImpl: HistoryRepository {

    private let realm = try! Realm()
    
    public init() { }
    
    
    public func select(keyword: String, type: HistoryType) {
        let type: ROType = type == .map ? .map : .lottery
        
        if let history = realm.objects(HistoryRO.self).first(where: {
            $0.type == type && $0.keyword == keyword
        }) {
            update(history: history, type: type)
        } else {
            save(keyword: keyword, type: type)
        }
    }
    
    public func save(keyword: String, type: ROType) {
        let type: ROType = type == .map ? .map : .lottery
        let history = HistoryRO()
        history.keyword = keyword
        history.type = type
        history.date = Date()
        
        try! realm.write {
            realm.add(history)
        }
    }
    
    public func update(history: HistoryRO, type: ROType) {
        try! realm.write {
            history.date = Date()
        }
    }
    
    public func load(type: HistoryType) -> [History] {
        let type: ROType = type == .map ? .map : .lottery
        
        let result = realm.objects(HistoryRO.self)
            .sorted(byKeyPath: "date", ascending: false)
            .filter { $0.type == type }
        
        return result.compactMap { object -> History? in
            return object.toEntity()
        }
    }
    
    public func delete(keyword: String, type: HistoryType) {
        let type: ROType = type == .map ? .map : .lottery
        
        let history = realm.objects(HistoryRO.self).first(where: {
            $0.type == type && $0.keyword == keyword
        })!
        
        try! realm.write {
            realm.delete(history)
        }
    }
    
    public func clear(type: HistoryType) {
        let type: ROType = type == .map ? .map : .lottery
        
        try! realm.write {
            let histories = realm.objects(HistoryRO.self).filter { $0.type == type }
            realm.delete(histories)
        }
    }
    
}
