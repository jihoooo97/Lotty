//
//  DrawnLotteryView.swift
//  RandomFeature
//
//  Created by 유지호 on 6/21/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core
import UIComponent

import UIKit

public final class DrawnLotteryView: UIStackView {
    
    private let topLine = DottedLine()
    private let game1View = GameView("A 게임")
    private let game2View = GameView("B 게임")
    private let game3View = GameView("C 게임")
    private let game4View = GameView("D 게임")
    private let game5View = GameView("E 게임")
    private let bottomLine = DottedLine()
    
    private var gameList: [GameView] = []
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUIProperty()
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public func drawLottery(with numberSets: [[Int]]) {
        guard numberSets.count >= 5 else { return }
        
        gameList.enumerated().forEach { offset, game in
            game.alpha = 0.0
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(offset) * 0.1) {
                game.alpha = 1.0
                game.configure(with: numberSets[offset])
            }
        }
    }
    
    private func setUIProperty() {
        self.axis = .vertical
        self.spacing = 16
        
        gameList = [game1View, game2View, game3View, game4View, game5View]
    }
    
    private func setLayout() {
        self.addArrangedSubviews(
            topLine,
            game1View, game2View, game3View, game4View, game5View,
            bottomLine
        )
        
        topLine.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        game1View.snp.makeConstraints { make in
            make.height.equalTo(16)
        }
        
        bottomLine.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
}
