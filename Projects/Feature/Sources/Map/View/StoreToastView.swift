//
//  StoreToastView.swift
//  MapFeature
//
//  Created by 유지호 on 6/15/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import Domain

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import UIComponent

public final class StoreToastView: UIView {
    
    private lazy var stackView = UIStackView()
    private lazy var contentStackView = UIStackView()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .semibold)
        return label
    }()
    
    private let addressIconLabel = IconLabelView(image: .init(systemName: "mappin.and.ellipse"), textColor: .darkGray)
    private let phoneIconLabel = IconLabelView(image: .init(systemName: "phone.fill"), textColor: .darkGray)
    
    private lazy var navigationButton = UIButton()
    
    private var bag = DisposeBag()
    
    private var storeCoord: (x: Double, y: Double) = (0, 0)
    private var distance: Double?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUIProperty()
        setLayout()
        
        navigationButton.rx.tap
            .asDriver()
            .drive { _ in
                let startQuery = "sp=\(LocationManager.shared.latitude),\(LocationManager.shared.longitude)"
                let endQuery = "&ep=\(self.storeCoord.y),\(self.storeCoord.x)"
                let transfortQuery = "&by=\(self.distance ?? 0 < 800 ? "FOOT" : "PUBLICTRANSIT")"
                
                let url = "kakaomap://route?" + startQuery + endQuery + transfortQuery
                
                if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
                    UIApplication.shared.open(openApp)
                } else {
                    let downApp = URL(string: "https://apps.apple.com/us/app/id304608425")!
                    UIApplication.shared.open(downApp)
                }
            }.disposed(by: bag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func bind(store: StoreModel) {
        self.nameLabel.text = store.storeName
        self.addressIconLabel.configure(text: store.roadAddress)
        self.phoneIconLabel.configure(text: store.phone)
        self.storeCoord = (x: Double(store.x)!, y: Double(store.y)!)
        self.distance = Double(store.distance)
    }
    
    private func setUIProperty() {
        self.backgroundColor = .systemBackground
        self.layer.cornerRadius = 16
        self.applyShadow(y: 0.5)
        
        stackView = {
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.alignment = .center
            stackView.spacing = 4
            return stackView
        }()
        
        contentStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .equalSpacing
            stackView.alignment = .leading
            stackView.spacing = 4
            return stackView
        }()
        
        navigationButton = {
            let button = UIButton()
            button.configuration = .borderedProminent()
            
            let title = NSAttributedString(string: "길찾기", attributes: [.font: UIFont.systemFont(ofSize: 12.0, weight: .medium)])
            button.configuration?.attributedTitle = AttributedString(title)
            
            button.configuration?.image = .init(systemName: "paperplane.fill")
            button.configuration?.imagePadding = 8
            button.configuration?.imagePlacement = .top
            
            button.configuration?.background.cornerRadius = 12
            return button
        }()
    }
    
    private func setLayout() {
        self.addSubview(stackView)
        stackView.addArrangedSubviews(contentStackView, navigationButton)
        contentStackView.addArrangedSubviews(nameLabel, addressIconLabel, phoneIconLabel)
        
        contentStackView.setCustomSpacing(8, after: nameLabel)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(12)
        }
        
        navigationButton.snp.makeConstraints { make in
            make.size.equalTo(60)
        }
    }
    
}
