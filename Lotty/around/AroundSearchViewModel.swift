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

    let historyListRelay = BehaviorRelay<[String]>(value: [])
    
    override init() {
        super.init()
        
        getHistoryList()
    }
    
    deinit {
        Storage.store(
            historyListRelay.value,
            to: .documents,
            as: "location_history.json"
        )
    }
    
    func getHistoryList() {
        historyListRelay.accept(Storage.retrive(
            "location_history.json",
            from: .documents,
            as: [String].self
        ) ?? [])
    }
    
}
