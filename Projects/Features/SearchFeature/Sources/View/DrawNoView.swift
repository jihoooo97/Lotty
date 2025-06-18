//
//  DrawNoView.swift
//  SearchFeature
//
//  Created by 유지호 on 6/18/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core

import UIKit

public final class DrawNoView: UIStackView {
    
    private lazy var titleLabel = UILabel()
    private lazy var drawNoStackView = UIStackView()
    
    private lazy var firstNoLabel = LotteryBall()
    private lazy var secondNoLabel = LotteryBall()
    private lazy var thirdNoLabel = LotteryBall()
    private lazy var fourthNoLabel = LotteryBall()
    private lazy var fifthNoLabel = LotteryBall()
    private lazy var sixthNoLabel = LotteryBall()
    private lazy var plusIcon = UIImageView()
    private lazy var bonusNoLabel = LotteryBall()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUIProperty()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure(drawNo: Int..., bonusNo: Int) {
        guard drawNo.count == 6 else { return }
        firstNoLabel.number = drawNo[0]
        secondNoLabel.number = drawNo[1]
        thirdNoLabel.number = drawNo[2]
        fourthNoLabel.number = drawNo[3]
        fifthNoLabel.number = drawNo[4]
        sixthNoLabel.number = drawNo[5]
        bonusNoLabel.number = bonusNo
    }
    
    private func setUIProperty() {
        self.axis = .vertical
        self.alignment = .center
        self.spacing = 8
        
        drawNoStackView.spacing = 4
        
        titleLabel = {
            let label = UILabel()
            label.text = "당첨번호"
            label.font = .systemFont(ofSize: 16.0, weight: .semibold)
            label.numberOfLines = 1
            return label
        }()
        
        [firstNoLabel, secondNoLabel, thirdNoLabel, fourthNoLabel, fifthNoLabel, sixthNoLabel, bonusNoLabel].forEach { label in
            label.font = .systemFont(ofSize: 18.0, weight: .semibold)
            label.textColor = .white
            label.textAlignment = .center
            label.numberOfLines = 0
            label.layer.cornerRadius = 18
            label.layer.masksToBounds = true
        }
        
        plusIcon = {
            let imageView = UIImageView()
            imageView.image = .init(systemName: "plus")
            imageView.tintColor = .label
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()
    }
    
    private func setLayout() {
        self.addArrangedSubviews(titleLabel, drawNoStackView)
        drawNoStackView.addArrangedSubviews(
            firstNoLabel, secondNoLabel, thirdNoLabel, fourthNoLabel, fifthNoLabel, sixthNoLabel,
            plusIcon, bonusNoLabel
        )
        
        drawNoStackView.snp.makeConstraints { make in
            make.height.equalTo(36)
        }
        
        [firstNoLabel, secondNoLabel, thirdNoLabel, fourthNoLabel, fifthNoLabel, sixthNoLabel, bonusNoLabel].forEach {
            $0.snp.makeConstraints { make in
                make.width.equalTo(36)
            }
        }
    }
    
}
