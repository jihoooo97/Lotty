//
//  LotteryBall.swift
//  SearchFeature
//
//  Created by 유지호 on 6/18/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import UIKit

public final class LotteryBall: UILabel {
    
    public var number: Int = 0 {
        didSet {
            configure(number)
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.font = .systemFont(ofSize: 18.0, weight: .semibold)
        self.textColor = .white
        self.textAlignment = .center
        self.numberOfLines = 0
        self.layer.cornerRadius = 18
        self.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(_ number: Int) {
        self.text = "\(number)"
        
        switch number {
        case 1...10:
            self.backgroundColor = .init(red: 0.984, green: 0.773, blue: 0.0, alpha: 1.0)
        case 11...20:
            self.backgroundColor = .init(red: 0.412, green: 0.784, blue: 0.949, alpha: 1.0)
        case 21...30:
            self.backgroundColor = .init(red: 1.0, green: 0.510, blue: 0.447, alpha: 1.0)
        case 31...40:
            self.backgroundColor = .init(red: 0.667, green: 0.667, blue: 0.667, alpha: 1.0)
        default:
            self.backgroundColor = .init(red: 0.686, green: 0.847, blue: 0.251, alpha: 1.0)
        }
    }
    
}
