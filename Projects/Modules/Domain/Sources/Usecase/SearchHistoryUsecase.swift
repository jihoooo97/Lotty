//
//  SearchHistoryUsecase.swift
//  Domain
//
//  Created by 유지호 on 6/14/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core

import Foundation
import RxSwift
import RxRelay

public enum SearchHistoryType: String {
    case store = "StoreHistory"
    case lottery = "LotteryHistory"
}

public protocol SearchHistoryUsecase {
    var historyList: BehaviorRelay<[HistoryModel]> { get }
    
    func save()
    func add(keyword: String)
    func load()
    func remove(keyword: String)
    func clear()
}

public final class DefaultSearchHistoryUsecase: SearchHistoryUsecase {
    
    public let historyList = BehaviorRelay<[HistoryModel]>(value: [])
                                    
    private let historyType: SearchHistoryType
    
    public init(_ historyType: SearchHistoryType) {
        self.historyType = historyType
    }
    
    
    public func save() {
        do {
            let data = try JSONEncoder().encode(historyList.value)
            UserDefaults.standard.set(data, forKey: historyType.rawValue)
        } catch {
            debugPrint("Failed to encode History:", error.localizedDescription)
        }
    }
    
    public func add(keyword: String) {
        var histories = historyList.value
        histories.removeAll { $0.keyword == keyword }
        histories.insert(.init(keyword: keyword, date: .now), at: 0)
        historyList.accept(histories)
        save()
    }
    
    public func load() {
        do {
            guard let data = UserDefaults.standard.data(forKey: historyType.rawValue) else {
                debugPrint("Failed to load History")
                return
            }
            
            let histories = try JSONDecoder().decode([HistoryModel].self, from: data).sorted(by: { $0.date > $1.date })
            historyList.accept(histories)
        } catch {
            debugPrint("Failed to decode History:", error.localizedDescription)
            return
        }
    }
    
    public func remove(keyword: String) {
        var histories = historyList.value
        histories.removeAll { $0.keyword == keyword }
        historyList.accept(histories)
        save()
    }
    
    public func clear() {
        historyList.accept([])
        UserDefaults.standard.removeObject(forKey: historyType.rawValue)
    }
    
}
