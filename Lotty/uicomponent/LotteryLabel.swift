//
//  LotteryLabel.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/08.
//

import UIKit
import Then

final class LotteryLabel: UILabel {

    var lotteryNo: Int = 0 {
        didSet {
            self.text = "\(lotteryNo)"
            self.setRound()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        self.textAlignment = .center
        self.textColor = .white
        self.font = LottyFonts.bold(size: 18)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 18
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
