//
//  SearchHistoryTableViewHeader.swift
//  UIComponent
//
//  Created by 유지호 on 6/12/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public final class SearchHistoryTableViewHeader: UIView {
    
    private lazy var titleLabel = UILabel()
    private lazy var button = UIButton()
    
    public var buttonAction: (() -> Void)? = nil
    
    private var bag = DisposeBag()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUIProperty()
        setLayout()
        
        button.rx.tap
            .throttle(.milliseconds(200), scheduler: MainScheduler.instance)
            .bind { [weak self] _ in
                self?.buttonAction?()
            }.disposed(by: bag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(title: String = "헤더 제목") {
        self.init(frame: .zero)
        
        titleLabel.text = title
    }
    
    
    private func setUIProperty() {
        titleLabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14.0, weight: .semibold)
            label.textColor = .lightGray
            return label
        }()
        
        button = {
            let button = UIButton()
            button.configuration = .plain()
            button.configuration?.baseForegroundColor = .lightGray
            
            button.configuration?.title = "전체삭제"
            button.configuration?.titleTextAttributesTransformer = .init({ container in
                var title = container
                title.font = .systemFont(ofSize: 14.0, weight: .medium)
                return title
            })
            
            button.configuration?.image = .init(systemName: "trash")
            button.configuration?.imagePadding = 2
            button.configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 10.0, weight: .medium)
            return button
        }()
    }
    
    private func setLayout() {
        self.addSubviews(titleLabel, button)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
            make.right.verticalEdges.equalToSuperview()
        }
    }
    
}
