//
//  HistoryUsecase.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/19.
//

public enum HistoryType  {
    case map
    case lottery
}

public protocol HistoryUsecaseProtocol {
    func select(keyword: String, type: HistoryType)
    func load(type: HistoryType) -> [History]
    func delete(keyword: String, type: HistoryType)
    func clear(type: HistoryType)
}

public final class HistoryUsecase: HistoryUsecaseProtocol {
    
    private let repository: HistoryRepository
    
    public init(repository: HistoryRepository) {
        self.repository = repository
    }
    
    
    public func select(keyword: String, type: HistoryType) {
        repository.select(keyword: keyword, type: type)
    }
    
    public func load(type: HistoryType) -> [History] {
        return repository.load(type: type)
    }
    
    public func delete(keyword: String, type: HistoryType) {
        repository.delete(keyword: keyword, type: type)
    }
    
    public func clear(type: HistoryType) {
        repository.clear(type: type)
    }

}
