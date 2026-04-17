//
//  MapFeatureBuilder.swift
//  MapFeature
//
//  Created by 유지호 on 6/14/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import Domain

public final class MapFeatureBuilder {
    
    public let storeUsecase = DIContainer.shared.resolve(StoreUsecase.self)
    
    public init() { }
    
    
    // MARK: 네비게이션을 하는 VC에선 builder 인스턴스를 가지고 있어야 push 할 VC build 가능
    public func buildLottyMapVC(builder: MapFeatureBuilder) -> LottyMapViewController {
        let viewModel = LotteryMapViewModel(storeUsecase: storeUsecase)
        let lottyMapViewController = LottyMapViewController(builder: builder, viewModel: viewModel)
        return lottyMapViewController
    }
    
    public func buildStoreSearchVC() -> StoreSearchViewController {
        let viewModel = StoreSearchViewModel(storeUsecase: storeUsecase, historyUsecase: DefaultSearchHistoryUsecase(.store))
        let storeSearchViewController = StoreSearchViewController(viewModel: viewModel)
        return storeSearchViewController
    }
    
}
