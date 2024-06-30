//
//  LotteryDetailView.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import Domain
import UIKit

public final class LotteryDetailView: UIView {

    private lazy var turnLabel = UILabel()
    private lazy var dateLabel = UILabel()
    
    private let lotteryView = LotteryView()
    
    private lazy var winnerCountTitleLabel = UILabel()
    private lazy var winnerCountLabel = UILabel()
    private let winnerCountIndicator = UIView()
    
    private lazy var winnerPrizeAmountTitleLabel = UILabel()
    private lazy var winnerPrizeAmountLabel = UILabel()
    private let winnerPrizeAmountIndicator = UIView()
    
    private lazy var prizeAmountTitleLabel = UILabel()
    private lazy var prizeAmountLabel = UILabel()
    private let prizeAmountIndicator = UIView()
    
    private lazy var totalSellAmountTitleLabel = UILabel()
    private lazy var totalSellAmountLabel = UILabel()
    
    public init() {
        super.init(frame: .zero)
        
        initAttributes()
        initConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func bind(lottery: Lottery) {
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
        turnLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = LottyColors.G900
            label.font = LottyFonts.semiBold(size: 19)
            label.text = "0000회"
            return label
        }()

        dateLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = LottyColors.Placeholder
            label.font = LottyFonts.medium(size: 15)
            label.text = "0000-00-00"
            return label
        }()

        winnerCountTitleLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = LottyColors.B500
            label.font = LottyFonts.semiBold(size: 16)
            label.text = "당첨자 수"
            return label
        }()

        winnerCountLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = LottyColors.G900
            label.font = LottyFonts.medium(size: 16)
            label.text = "0"
            return label
        }()

        winnerPrizeAmountTitleLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = LottyColors.B500
            label.font = LottyFonts.semiBold(size: 16)
            label.text = "1인 당첨 금액"
            return label
        }()

        winnerPrizeAmountLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = LottyColors.G900
            label.font = LottyFonts.medium(size: 16)
            label.text = "0"
            return label
        }()
        
        prizeAmountTitleLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = LottyColors.B500
            label.font = LottyFonts.semiBold(size: 16)
            label.text = "총 당첨 금액"
            return label
        }()

        prizeAmountLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = LottyColors.G900
            label.font = LottyFonts.medium(size: 16)
            label.text = "0"
            return label
        }()
        
        totalSellAmountTitleLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = LottyColors.B500
            label.font = LottyFonts.semiBold(size: 16)
            label.text = "총 복권 판매 금액"
            return label
        }()

        totalSellAmountLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = LottyColors.G900
            label.font = LottyFonts.medium(size: 16)
            label.text = "0"
            return label
        }()
        
        winnerCountIndicator.backgroundColor = LottyColors.G50
        winnerPrizeAmountIndicator.backgroundColor = LottyColors.G50
        prizeAmountIndicator.backgroundColor = LottyColors.G50
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
