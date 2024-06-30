//
//  LotteryLabel.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/08.
//

import UIKit

public final class LotteryLabel: UILabel {

    public var lotteryNo: Int = 0 {
        didSet {
            self.text = "\(lotteryNo)"
            self.setRound()
        }
    }
    
    public override init(frame: CGRect) {
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
    
    
    func setRound() {
        guard let text = self.text else { return }
        guard let drwNo = Int(text) else { return }
        switch drwNo {
        case  1...10:
            self.backgroundColor = LottyColors.firstColor
        case 11...20:
            self.backgroundColor = LottyColors.secondColor
        case 21...30:
            self.backgroundColor = LottyColors.thirdColor
        case 31...40:
            self.backgroundColor = LottyColors.fourthColor
        default:
            self.backgroundColor = LottyColors.fifthColor
        }
    }
    
}
