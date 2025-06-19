//
//  SearchFeatureBuilder.swift
//  SearchFeature
//
//  Created by 유지호 on 6/18/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import Domain

public final class SearchFeatureBuilder {
    
    public let lotteryUsecase = DIContainer.shared.resolve(LotteryUsecase.self)
    
    public init() { }
    
    
    public func buildLotteryMainVC(builder: SearchFeatureBuilder) -> LotteryMainViewController {
        let viewModel = LotteryMainViewModel(lotteryUsecase: lotteryUsecase)
        let lotteryMainViewController = LotteryMainViewController(builder: builder, viewModel: viewModel)
        return lotteryMainViewController
    }
    
    public func buildLotterySearchVC() -> LotterySearchViewController {
        let viewModel = LotterySearchViewModel(lotteryUsecase: lotteryUsecase, historyUsecase: DefaultSearchHistoryUsecase(.lottery))
        let lotterySearchViewController = LotterySearchViewController(viewModel: viewModel)
        lotterySearchViewController.hidesBottomBarWhenPushed = true
        return lotterySearchViewController
    }
    
}
