//
//  LotteryViewModel.swift
//  Lotty
//
//  Created by JihoMac on 2022/04/05.
//

import UIKit

class LotteryViewModel {
    var lotteryItems: [LotteryItem] = []
    var numberOfLotteryList: Int {
        return lotteryItems.count
    }
}
