//
//  TextFieldAccessoryView.swift
//  CommonUI
//
//  Created by 유지호 on 6/30/24.
//  Copyright © 2024 jiho. All rights reserved.
//

import UIKit

public class TextFieldAccessoryView: UIView {
    
    public let leftButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("취소", for: .normal)
        return button
    }()
    
    public let rightButton: UIButton = {
        let button = UIButton(configuration: .plain())
        button.setTitle("완료", for: .normal)
        return button
    }()
    
    
    public override init(frame: CGRect) {
        super.init(frame: .init(x: 0, y: 0, width: 0, height: 44))
        
        backgroundColor = .white
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setLayout() {
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        
        leftButton.snp.makeConstraints {
            $0.left.centerY.equalToSuperview()
        }
        
        rightButton.snp.makeConstraints {
            $0.right.centerY.equalToSuperview()
        }
    }
    
}
