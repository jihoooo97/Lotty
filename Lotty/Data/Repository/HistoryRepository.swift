//
//  HistoryRepository.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import RealmSwift

final class HistoryRepository {

    private let realm = try! Realm()
    
    init() { }
    
    
    func select(keyword: String, type: ROType) {
        if let history = realm.objects(HistoryRO.self).first(where: {
            $0.type == type && $0.keyword == keyword
        }) {
            update(history: history, type: type)
        } else {
            save(keyword: keyword, type: type)
        }
    }
    
    func save(keyword: String, type: ROType) {
        let history = HistoryRO()
        history.keyword = keyword
        history.type = type
        history.date = Date()
        
        try! realm.write {
            realm.add(history)
        }
    }
    
    func update(history: HistoryRO, type: ROType) {
        try! realm.write {
            history.date = Date()
        }
    }
    
    func load(type: ROType) -> [History] {
        let result = realm.objects(HistoryRO.self)
            .sorted(byKeyPath: "date", ascending: false)
            .filter { $0.type == type }
        
        return result.compactMap { object -> History? in
            return object.toEntity()
        }
    }
    
    func delete(keyword: String, type: ROType) {
        let history = realm.objects(HistoryRO.self).first(where: {
            $0.type == type && $0.keyword == keyword
        })!
        
        try! realm.write {
            realm.delete(history)
        }
    }
    
    func clear(type: ROType) {
        try! realm.write {
            let histories = realm.objects(HistoryRO.self).filter { $0.type == type }
            realm.delete(histories)
        }
    }
    
}
