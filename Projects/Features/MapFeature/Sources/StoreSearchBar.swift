//
//  StoreSearchBar.swift
//  Map
//
//  Created by 유지호 on 6/3/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import BaseFeature

import UIKit

final class StoreSearchBar: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setConfiguration() {
        self.configuration = .plain()
        self.backgroundColor = .white
        self.contentHorizontalAlignment = .leading
        
        border()
        applyShadow(y: 0.5, blur: 2)
        
        self.configuration?.title = "지역 이름으로 검색하세요."
        self.configuration?.image = .init(systemName: "magnifyingglass")?
        self.configuration?.imagePadding = 12
        self.configuration?.baseForegroundColor = .lightGray
        
        self.configurationUpdateHandler = { button in
            self.layer.opacity = button.state == .highlighted ? 0.8 : 1.0
        }
    }
    
}
