//
//  LotteryMapViewModel.swift
//  MapFeature
//
//  Created by 유지호 on 6/14/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import BaseFeature
import Core
import Domain

import Foundation
import CoreLocation
import RxSwift
import RxRelay

public final class LotteryMapViewModel: ViewModelable {
    
    private let storeUsecase: StoreUsecase
    private var bag = DisposeBag()
    
    public struct Input {
        let viewDidLoad: Observable<Void>
        let cameraPositionDidChange: Observable<CLLocationCoordinate2D>
        let refreshButtonDidTap: Observable<Void>
    }
    
    public struct Output {
        let userLocation = PublishRelay<CLLocationCoordinate2D>()
        let storeSearchResult = PublishRelay<StoreModel?>()
        let storeList = PublishRelay<[StoreModel]>()
    }
    
    init(storeUsecase: StoreUsecase) {
        self.storeUsecase = storeUsecase
    }
    
    deinit {
        bag = .init()
    }
    
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        bindOutput(with: output)
        
        input.cameraPositionDidChange
            .withUnretained(self)
            .subscribe { owner, position in
                output.userLocation.accept(position)
            }.disposed(by: bag)
        
        input.refreshButtonDidTap
            .withLatestFrom(output.userLocation)
            .withUnretained(self)
            .subscribe { owner, position in
                owner.storeUsecase.getStoreList(x: position.longitude, y: position.latitude)
            }.disposed(by: bag)
        
        return output
    }
    
    private func bindOutput(with output: Output) {
        storeUsecase.storeSearchResult
            .subscribe { store in
                output.storeSearchResult.accept(store)
            }.disposed(by: bag)
        
        storeUsecase.storeList
            .subscribe { storeList in
                output.storeList.accept(storeList)
            }.disposed(by: bag)
    }
    
    public func requestStoreList(
        x: Double = LocationManager.shared.longitude,
        y: Double = LocationManager.shared.latitude
    ) {
        storeUsecase.getStoreList(x: x, y: y)
    }
    
}
