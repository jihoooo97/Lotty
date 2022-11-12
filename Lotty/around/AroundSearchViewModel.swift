//
//  AroundSearchViewModel.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/07.
//

import Foundation
import RxSwift
import RxRelay

final class AroundSearchViewModel: BaseViewModel {

    private var _historyList: [String] = []
    let historyListRelay = BehaviorRelay<[String]>(value: [])
    
    
    override init() {
        super.init()
        
        loadHistory()
    }
    
    deinit {
        saveHistory()
    }
    
    
    func loadHistory() {
        _historyList = Storage.retrive(
            "location_history.json",
            from: .documents,
            as: [String].self
        ) ?? []
        historyListRelay.accept(_historyList)
    }
    
    func saveHistory() {
        Storage.store(
            _historyList,
            to: .documents,
            as: "location_history.json"
        )
    }
    
    func updateHistory(index: Int, query: String) {
        if index > 0 { // 리스트 클릭해서 검색
            _historyList.remove(at: index)
            _historyList.insert(query, at: 0)
        } else { // 회차 입력해서 검색
            _historyList = _historyList.filter { $0 != query }
            _historyList.insert(query, at: 0)
        }
        historyListRelay.accept(_historyList)
    }
    
    func deleteHistory(index: Int) {
        _historyList.remove(at: index)
        historyListRelay.accept(_historyList)
    }
    
}
