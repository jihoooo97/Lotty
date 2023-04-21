//
//  UILabel+Extension.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/08.
//

import UIKit

extension UILabel {

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
