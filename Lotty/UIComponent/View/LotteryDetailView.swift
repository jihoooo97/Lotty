//
//  LotteryDetailView.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import UIKit

final class LotteryDetailView: UIView {

    var turnLabel = UILabel()
    var dateLabel = UILabel()
    
    var lotteryView = LotteryView()
    
    var winnerCountTitleLabel = UILabel()
    var winnerCountLabel = UILabel()
    var winnerCountIndicator = UIView()
    
    var winnerPrizeAmountTitleLabel = UILabel()
    var winnerPrizeAmountLabel = UILabel()
    var winnerPrizeAmountIndicator = UIView()
    
    var prizeAmountTitleLabel = UILabel()
    var prizeAmountLabel = UILabel()
    var prizeAmountIndicator = UIView()
    
    var totalSellAmountTitleLabel = UILabel()
    var totalSellAmountLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        initAttributes()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func bind(lottery: Lottery) {
        turnLabel.text = "\(lottery.turn)회"
        dateLabel.text = lottery.drawNumberDate
        winnerCountLabel.text = "\(lottery.winnerCount)명"
        winnerPrizeAmountLabel.text = lottery.winnerPrizeAmount + "원"
        prizeAmountLabel.text = lottery.prizeAmount + "원"
        totalSellAmountLabel.text = lottery.totalSellAmount + "원"
        
        let lotteryNumber = [lottery.drawNo1, lottery.drawNo2, lottery.drawNo3,
                             lottery.drawNo4, lottery.drawNo5, lottery.drawNo6, lottery.bonusNo]
        lotteryView.bind(lotteryNumber: lotteryNumber)
    }
    
    private func initAttributes() {
        turnLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.semiBold(size: 19)
            $0.text = "0000회"
        }

        dateLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.Placeholder
            $0.font = LottyFonts.medium(size: 15)
            $0.text = "0000-00-00"
        }

        winnerCountTitleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.B500
            $0.font = LottyFonts.semiBold(size: 16)
            $0.text = "당첨자 수"
        }

        winnerCountLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.medium(size: 16)
            $0.text = "0"
        }

        winnerCountIndicator = UIView().then {
            $0.backgroundColor = LottyColors.G50
        }

        winnerPrizeAmountTitleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.B500
            $0.font = LottyFonts.semiBold(size: 16)
            $0.text = "1인 당첨 금액"
        }

        winnerPrizeAmountLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.medium(size: 16)
            $0.text = "0"
        }

        
        winnerPrizeAmountIndicator = UIView().then {
            $0.backgroundColor = LottyColors.G50
        }
        
        prizeAmountTitleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.B500
            $0.font = LottyFonts.semiBold(size: 16)
            $0.text = "총 당첨 금액"
        }

        prizeAmountLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.medium(size: 16)
            $0.text = "0"
        }

        prizeAmountIndicator = UIView().then {
            $0.backgroundColor = LottyColors.G50
        }
        
        totalSellAmountTitleLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.B500
            $0.font = LottyFonts.semiBold(size: 16)
            $0.text = "총 복권 판매 금액"
        }

        totalSellAmountLabel = UILabel().then {
            $0.textAlignment = .center
            $0.textColor = LottyColors.G900
            $0.font = LottyFonts.medium(size: 16)
            $0.text = "0"
        }
    }
    
    private func initConstraints() {
        [turnLabel, dateLabel, lotteryView,
         winnerCountTitleLabel, winnerCountLabel, winnerCountIndicator,
         winnerPrizeAmountTitleLabel, winnerPrizeAmountLabel, winnerPrizeAmountIndicator,
         prizeAmountTitleLabel, prizeAmountLabel, prizeAmountIndicator,
         totalSellAmountTitleLabel, totalSellAmountLabel].forEach {
            self.addSubview($0)
        }
        
        turnLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(24)
        }

        dateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-24)
            $0.centerY.equalTo(turnLabel)
        }

        lotteryView.snp.makeConstraints {
            $0.left.equalTo(lotteryView.no1Label.snp.left)
            $0.right.equalTo(lotteryView.bonusNoLabel.snp.right)
            $0.top.equalTo(turnLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(36)
        }

        winnerCountTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.top.equalTo(lotteryView.snp.bottom).offset(20)
        }

        winnerCountLabel.snp.makeConstraints {
            $0.leading.equalTo(winnerCountTitleLabel)
            $0.top.equalTo(winnerCountTitleLabel.snp.bottom).offset(8)
        }

        winnerCountIndicator.snp.makeConstraints {
            $0.leading.equalTo(winnerCountTitleLabel)
            $0.top.equalTo(winnerCountLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
        }

        winnerPrizeAmountTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(winnerCountTitleLabel)
            $0.top.equalTo(winnerCountIndicator.snp.bottom).offset(12)
        }

        winnerPrizeAmountLabel.snp.makeConstraints {
            $0.leading.equalTo(winnerCountTitleLabel)
            $0.top.equalTo(winnerPrizeAmountTitleLabel.snp.bottom).offset(8)
        }

        winnerPrizeAmountIndicator.snp.makeConstraints {
            $0.leading.equalTo(winnerCountTitleLabel)
            $0.top.equalTo(winnerPrizeAmountLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
        }

        prizeAmountTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(winnerCountTitleLabel)
            $0.top.equalTo(winnerPrizeAmountIndicator.snp.bottom).offset(12)
        }

        prizeAmountLabel.snp.makeConstraints {
            $0.leading.equalTo(winnerCountTitleLabel)
            $0.top.equalTo(prizeAmountTitleLabel.snp.bottom).offset(8)
        }

        prizeAmountIndicator.snp.makeConstraints {
            $0.leading.equalTo(winnerCountTitleLabel)
            $0.top.equalTo(prizeAmountLabel.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
        }

        totalSellAmountTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(winnerCountTitleLabel)
            $0.top.equalTo(prizeAmountIndicator.snp.bottom).offset(12)
        }

        totalSellAmountLabel.snp.makeConstraints {
            $0.leading.equalTo(winnerCountTitleLabel)
            $0.top.equalTo(totalSellAmountTitleLabel.snp.bottom).offset(8)
        }
    }
    
}
