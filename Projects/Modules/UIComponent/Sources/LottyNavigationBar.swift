//
//  LottyNavigationBar.swift
//  UIComponent
//
//  Created by 유지호 on 6/6/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core

import UIKit

public class LottyNavigationBar: UIStackView {
    
    private lazy var leftButton = UIButton()
    private lazy var title = UILabel()
    private lazy var rightButton = UIButton()
 
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUIProperty()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUIProperty() {
        
    }
    
    private func setLayout() {
        
    }
    
}
