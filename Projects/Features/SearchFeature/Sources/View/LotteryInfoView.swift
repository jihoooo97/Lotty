//
//  LotteryInfoView.swift
//  SearchFeature
//
//  Created by 유지호 on 6/19/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import Domain

import UIKit

public final class LotteryInfoView: UIStackView {
    
    private lazy var drawnDateLabel = UILabel()
    private lazy var drawNoView = DrawNoView()
    private lazy var winAmountLabel = UILabel()
    private lazy var winnerCountLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUIProperty()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with lottery: LotteryModel) {
        drawnDateLabel.text = lottery.drawnDate
        drawNoView.configure(winNo: lottery.winNumbers, bonusNo: lottery.bonusNo)
        
        let winnerCountString = NSMutableAttributedString(string: lottery.winnerCount.formatted() + "명")
        let winnerCountAttributedString = NSAttributedString(
            string: " 당첨",
            attributes: [.font: UIFont.monospacedSystemFont(ofSize: 14.0, weight: .medium)]
        )
        
        winnerCountString.append(winnerCountAttributedString)
        winnerCountLabel.attributedText = winnerCountString
        
        let winAmountAttributedString = NSMutableAttributedString(string: "인당 " + lottery.winnerPrizeAmount.formatted() + "원")
        winAmountAttributedString.addAttribute(
            .font,
            value: UIFont.monospacedSystemFont(ofSize: 14.0, weight: .medium),
            range: .init(location: 0, length: 2)
        )
        
        winAmountLabel.attributedText = winAmountAttributedString
    }
    
    private func setUIProperty() {
        self.axis = .vertical
        self.alignment = .center
        self.spacing = 8
        self.isLayoutMarginsRelativeArrangement = true
        self.layoutMargins = .init(top: 16, left: 0, bottom: 16, right: 0)
        
        drawnDateLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 16.0, weight: .medium)
            label.numberOfLines = 1
            return label
        }()
        
        winnerCountLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = .monospacedSystemFont(ofSize: 20.0, weight: .semibold)
            return label
        }()
        
        winAmountLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 24.0, weight: .medium)
            label.numberOfLines = 1
            return label
        }()
    }
    
    private func setLayout() {
        self.addArrangedSubviews(drawnDateLabel, drawNoView, winnerCountLabel, winAmountLabel)
    }
    
}
