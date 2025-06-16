//
//  UIStackView+Extension.swift
//  Core
//
//  Created by 유지호 on 6/12/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import UIKit

public extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { self.addArrangedSubview($0) }
    }
    
}
