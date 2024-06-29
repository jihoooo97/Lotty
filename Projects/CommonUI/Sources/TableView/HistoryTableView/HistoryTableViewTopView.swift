//
//  HistoryTableViewTopView.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/20.
//

import UIKit


public final class HistoryTableViewTopView: UIView {

    struct Constants {
        static let indicatorHeight: CGFloat = 10
        static let guideViewHeight: CGFloat = 50
        static let titleLabelLeft: CGFloat = 24
        static let clearButtonRight: CGFloat = 26
        static let clearButtonWidht: CGFloat = 70
        static let clearButtonHeight: CGFloat = 20
    }
    
    private lazy var topIndicator = UIView()
    private lazy var guideView = UIView()
    private lazy var titleLabel = UILabel()
    public lazy var clearButton = UIButton()

    private var isLottery: Bool
    
    public init(isLottry: Bool) {
        self.isLottery = isLottry
        super.init(frame: .zero)
        
        initAttributes()
        initContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initAttributes() {
        self.backgroundColor = .clear
        
        topIndicator.backgroundColor = LottyColors.G50
        guideView.backgroundColor = .clear

        titleLabel = {
            let label = UILabel()
            label.textAlignment = .center
            label.textColor = LottyColors.Placeholder
            label.font = LottyFonts.semiBold(size: 15)
            label.text = isLottery ? "최근 본 회차" : "최근 검색어"
            return label
        }()

        clearButton = {
            let button = UIButton()
            button.setTitle("전체 삭제", for: .normal)
            button.setTitleColor(LottyColors.Placeholder, for: .normal)
            button.titleLabel?.font = LottyFonts.semiBold(size: 13)
            let clearImage = LottyIcons.trashIcon.resize(width: 15).withTintColor(LottyColors.Placeholder)
            button.setImage(clearImage, for: .normal)
            return button
        }()
    }
    
    private func initContraints() {
        [topIndicator, guideView].forEach {
            self.addSubview($0)
        }
        
        [titleLabel, clearButton].forEach {
            guideView.addSubview($0)
        }
        
        topIndicator.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(Constants.indicatorHeight)
        }
        
        guideView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(topIndicator.snp.bottom)
            $0.height.equalTo(Constants.guideViewHeight)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(Constants.titleLabelLeft)
            $0.centerY.equalToSuperview()
        }

        clearButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-Constants.clearButtonRight)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(Constants.clearButtonWidht)
            $0.height.equalTo(Constants.clearButtonHeight)
        }
    }
    
}
