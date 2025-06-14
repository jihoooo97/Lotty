//
//  StoreMapper.swift
//  Domain
//
//  Created by 유지호 on 6/14/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core

import Foundation
import RxSwift

public protocol StoreMapper {
    func getStoreList(x: Double, y: Double) -> Observable<[StoreModel]>
    func searchStore(keyword: String) -> Observable<StoreModel?>
}
