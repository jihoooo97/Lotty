//
//  HistoryUsecase.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/19.
//

import RealmSwift

enum ROType: String, Codable, PersistableEnum  {
    case map
    case lottery
}

protocol HistoryUsecaseProtocol {
    func select(keyword: String, type: ROType)
    func load(type: ROType) -> [History]
    func delete(keyword: String, type: ROType)
    func clear(type: ROType)
}

final class HistoryUsecase: HistoryUsecaseProtocol {
    
    private let repository: HistoryRepository
    
    init(repository: HistoryRepository) {
        self.repository = repository
    }
    
    
    func select(keyword: String, type: ROType) {
        repository.select(keyword: keyword, type: type)
    }
    
    func load(type: ROType) -> [History] {
        return repository.load(type: type)
    }
    
    func delete(keyword: String, type: ROType) {
        repository.delete(keyword: keyword, type: type)
    }
    
    func clear(type: ROType) {
        repository.clear(type: type)
    }

}
