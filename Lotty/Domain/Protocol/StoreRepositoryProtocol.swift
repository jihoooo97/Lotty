//
//  StoreRepositoryProtocol.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import Foundation

protocol StoreRepositoryProtocol {
    func getStoreList(x: Double, y: Double, completion: @escaping(Result<[Store], Error>) -> Void)
    func searchStore(keyword: String, completion: @escaping(Result<Store?, Error>) -> Void)
}
