//
//  Int+Extension.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/08.
//

import Foundation

extension Int {

    func numberFormatter() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value: self))!
    }
    
}
