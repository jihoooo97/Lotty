//
//  LotteryCell.swift
//  SearchFeature
//
//  Created by 유지호 on 6/17/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import Domain

import UIKit

public final class LotteryCell: UITableViewCell {
    
    public static let identifier = "LotteryCell"
    
    private lazy var stackView = UIStackView()
    private lazy var titleView = UIView()
    private lazy var infoStackView = UIStackView()
    
    
    // MARK: Title Propertie
    
    private lazy var drawNoLabel = UILabel()
    private lazy var statusImage = UIImageView()
    
    
    // MARK: Info Properties
    
    private lazy var drawnDateLabel = UILabel()
    private lazy var drawNoView = DrawNoView()
    private lazy var winAmountLabel = UILabel()
    private lazy var winnerCountLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUIProperty()
        setLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    public func configure(with item: LotteryModel) {
        drawNoLabel.text = "\(item.drawNo)" + "회"
        statusImage.image = item.isOpen ? .init(systemName: "chevron.up") : .init(systemName: "chevron.down")
        
        drawnDateLabel.text = item.drawnDate
        drawNoView.configure(drawNo: item.winNo1, item.winNo2, item.winNo3, item.winNo4, item.winNo5, item.winNo6, bonusNo: item.bonusNo)
        
        let winnerCountString = NSMutableAttributedString(string: item.winnerCount.formatted() + "명")
        let winnerCountAttributedString = NSAttributedString(
            string: " 당첨",
            attributes: [.font: UIFont.monospacedSystemFont(ofSize: 14.0, weight: .medium)]
        )
        
        winnerCountString.append(winnerCountAttributedString)
        winnerCountLabel.attributedText = winnerCountString
        
        let winAmountAttributedString = NSMutableAttributedString(string: "인당 " + item.winnerPrizeAmount.formatted() + "원")
        winAmountAttributedString.addAttribute(
            .font,
            value: UIFont.monospacedSystemFont(ofSize: 14.0, weight: .medium),
            range: .init(location: 0, length: 2)
        )
        
        winAmountLabel.attributedText = winAmountAttributedString
        infoStackView.isHidden = !item.isOpen
    }

    private func setUIProperty() {
        self.selectionStyle = .none
        
        stackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            return stackView
        }()
        
        titleView = {
            let view = UIView()
            view.backgroundColor = .lightGray.withAlphaComponent(0.2)
            return view
        }()
        
        drawNoLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 18.0, weight: .semibold)
            label.textAlignment = .left
            label.numberOfLines = 1
            return label
        }()
        
        statusImage = {
            let imageView = UIImageView()
            imageView.tintColor = .darkGray
            return imageView
        }()
        
        infoStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 8
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = .init(top: 16, left: 0, bottom: 16, right: 0)
            return stackView
        }()
        
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
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews(titleView, infoStackView, UIView())
        titleView.addSubviews(drawNoLabel, statusImage)
        infoStackView.addArrangedSubviews(drawnDateLabel, drawNoView, winnerCountLabel, winAmountLabel)
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalToSuperview()
        }
        
        titleView.snp.makeConstraints { make in
            make.height.equalTo(56)
        }
        
        drawNoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        statusImage.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
    }
    
}
