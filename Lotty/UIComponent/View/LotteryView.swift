//
//  LotteryView.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import UIKit

final class LotteryView: UIView {

    var no1Label = LotteryLabel()
    var no2Label = LotteryLabel()
    var no3Label = LotteryLabel()
    var no4Label = LotteryLabel()
    var no5Label = LotteryLabel()
    var no6Label = LotteryLabel()
    var bonusNoLabel = LotteryLabel()
    var plusImage = UIImageView()
    
    struct Constants {
        static let lotterySize: CGFloat = 36
        static let plusImageSize: CGFloat = 20
        static let lotterySpace: CGFloat = 5
    }
    
    init() {
        super.init(frame: .zero)
        
        initAttributes()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bind(lotteryNumber: [Int]) {
        [no1Label, no2Label, no3Label, no4Label,
         no5Label, no6Label, bonusNoLabel].enumerated().forEach {
            $0.element.lotteryNo = lotteryNumber[$0.offset]
        }
    }
    
    private func initAttributes() {
        backgroundColor = .clear
        
        plusImage = UIImageView().then {
            $0.image = LottyIcons.plus
            $0.tintColor = LottyColors.G600
        }
    }
    
    private func initConstraints() {
        [no1Label, no2Label, no3Label, no4Label, no5Label, no6Label,
         bonusNoLabel, plusImage].forEach {
            self.addSubview($0)
        }

        no1Label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Constants.lotterySize)
        }

        no2Label.snp.makeConstraints {
            $0.leading.equalTo(no1Label.snp.trailing).offset(Constants.lotterySpace)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Constants.lotterySize)
        }

        no3Label.snp.makeConstraints {
            $0.leading.equalTo(no2Label.snp.trailing).offset(Constants.lotterySpace)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Constants.lotterySize)
        }

        no4Label.snp.makeConstraints {
            $0.leading.equalTo(no3Label.snp.trailing).offset(Constants.lotterySpace)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Constants.lotterySize)
        }

        no5Label.snp.makeConstraints {
            $0.leading.equalTo(no4Label.snp.trailing).offset(Constants.lotterySpace)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Constants.lotterySize)
        }

        no6Label.snp.makeConstraints {
            $0.leading.equalTo(no5Label.snp.trailing).offset(Constants.lotterySpace)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Constants.lotterySize)
        }

        plusImage.snp.makeConstraints {
            $0.leading.equalTo(no6Label.snp.trailing).offset(Constants.lotterySpace)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Constants.plusImageSize)
        }

        bonusNoLabel.snp.makeConstraints {
            $0.leading.equalTo(plusImage.snp.trailing).offset(Constants.lotterySpace)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(Constants.lotterySize)
        }
    }
    
}
