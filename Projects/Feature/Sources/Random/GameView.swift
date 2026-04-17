//
//  GameView.swift
//  RandomFeature
//
//  Created by 유지호 on 6/25/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import UIComponent

import UIKit

public final class GameView: UIStackView {
    
    private lazy var titleLabel = UILabel()
    private lazy var numberStackView = UIStackView()
    private let winNo1Label = RotationLabel()
    private let winNo2Label = RotationLabel()
    private let winNo3Label = RotationLabel()
    private let winNo4Label = RotationLabel()
    private let winNo5Label = RotationLabel()
    private let winNo6Label = RotationLabel()
    
    private let title: String
    
    public init(_ title: String) {
        self.title = title
        super.init(frame: .zero)
        
        setUIProperty()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func configure(with numbers: [Int]) {
        guard numbers.count >= 6 else { return }
        
        winNo1Label.configure(with: numbers[0])
        winNo2Label.configure(with: numbers[1])
        winNo3Label.configure(with: numbers[2])
        winNo4Label.configure(with: numbers[3])
        winNo5Label.configure(with: numbers[4])
        winNo6Label.configure(with: numbers[5])
    }
    
    private func setUIProperty() {
        self.spacing = 8
        
        titleLabel = {
            let label = UILabel()
            label.text = title
            label.font = .systemFont(ofSize: 16.0, weight: .bold)
            label.textAlignment = .center
            return label
        }()
        
        numberStackView = {
            let stackView = UIStackView()
            stackView.distribution = .fillEqually
            stackView.spacing = 4
            return stackView
        }()
    }
    
    private func setLayout() {
        self.addArrangedSubviews(titleLabel, numberStackView)
        numberStackView.addArrangedSubviews(
            winNo1Label, winNo2Label, winNo3Label,
            winNo4Label, winNo5Label, winNo6Label
        )
    }
    
}
