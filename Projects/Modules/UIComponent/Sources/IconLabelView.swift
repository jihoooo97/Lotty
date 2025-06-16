//
//  IconLabelView.swift
//  UIComponent
//
//  Created by 유지호 on 6/15/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import UIKit

public final class IconLabelView: UIStackView {

    private let icon = UIImageView()
    private let label = UILabel()

    public init(
        image: UIImage? = .init(systemName: "globe"),
        imageColor: UIColor = .lightGray,
        font: UIFont = .systemFont(ofSize: 14.0, weight: .medium),
        textColor: UIColor = .label
    ) {
        super.init(frame: .zero)
        
        icon.image = image
        icon.tintColor = imageColor
        label.font = font
        label.textColor = textColor
        
        setupUIProperty()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure(text: String) {
        label.text = text.isEmpty ? "-" : text
    }
    
    private func setupUIProperty() {
        icon.contentMode = .scaleAspectFit
        label.numberOfLines = 1

        self.axis = .horizontal
        self.alignment = .center
        self.spacing = 4
    }
    
    private func setLayout() {
        self.addArrangedSubviews(icon, label)
        
        icon.snp.makeConstraints { make in
            make.size.equalTo(16)
        }
    }

}
