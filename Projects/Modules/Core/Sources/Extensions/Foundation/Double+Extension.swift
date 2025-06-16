//
//  Double+Extension.swift
//  Core
//
//  Created by 유지호 on 6/15/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Foundation

public extension Double {
    
    func rounded(limit: Int = 6) -> Double {
        let rounded = Double(String(format: "%.\(limit)f", self))!
        return rounded
    }
    
}
