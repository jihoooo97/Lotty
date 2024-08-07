//
//  Int+Extension.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/08.
//

import Foundation

public extension Int {

    func toDigits() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
    
}
