//
//  SearchHistoryCell.swift
//  UIComponent
//
//  Created by 유지호 on 6/12/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import Domain

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public final class SearchHistoryCell: UITableViewCell {

    public static let identifier = "SearchHistoryCell"
    
    private lazy var stackView = UIStackView()
    private lazy var contentButton = UIButton()
    private lazy var dateLabel = UILabel()
    private lazy var deleteButton = UIButton()
    
    private var bag = DisposeBag()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setUIProperty()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        
        bag = .init()
    }
    
    
    public func bind(
        history: HistoryModel,
        contentAction: (() -> Void)? = nil,
        deleteAction: (() -> Void)? = nil
    ) {
        contentButton.configuration?.title = history.keyword
        dateLabel.text = history.date.monthDayString()
        
        contentButton.rx.tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind { _ in
                contentAction?()
            }.disposed(by: bag)
        
        deleteButton.rx.tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind { _ in
                deleteAction?()
            }.disposed(by: bag)
    }
    
    func setUIProperty() {
        self.selectionStyle = .none
        
        stackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.spacing = 4
            return stackView
        }()
        
        contentButton = {
            let button = UIButton()
            button.configuration = .plain()
            button.contentHorizontalAlignment = .leading
            button.configuration?.baseForegroundColor = .label

            button.configuration?.titleTextAttributesTransformer = .init({ container in
                var title = container
                title.font = .systemFont(ofSize: 16.0, weight: .medium)
                return title
            })
            
            button.configuration?.image = .init(systemName: "clock")
            button.configuration?.imagePadding = 14
            button.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 10.0)
            return button
        }()
        
        dateLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14.0, weight: .medium)
            label.textColor = .darkGray
            return label
        }()
        
        deleteButton = {
            let button = UIButton()
            button.configuration = .plain()
            button.configuration?.baseForegroundColor = .label
            button.configuration?.image = .init(systemName: "xmark")
            button.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 10.0, weight: .medium)
            return button
        }()
    }
    
    func setLayout() {
        contentView.addSubview(stackView)
        
        stackView.addArrangedSubviews(contentButton, dateLabel, deleteButton)
        
        stackView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(8)
            make.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints { make in
            make.size.equalTo(30)
        }
    }
    
}
