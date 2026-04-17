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
    private lazy var infoView = LotteryInfoView()
    
    
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

    
    public func configure(with lottery: LotteryModel) {
        drawNoLabel.text = "\(lottery.drawNo)" + "회"
        statusImage.image = lottery.isOpen ? .init(systemName: "chevron.up") : .init(systemName: "chevron.down")
        infoView.configure(with: lottery)
        infoView.isHidden = !lottery.isOpen
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
    }
    
    private func setLayout() {
        contentView.addSubview(stackView)
        stackView.addArrangedSubviews(titleView, infoView, UIView())
        titleView.addSubviews(drawNoLabel, statusImage)
        
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
