//
//  GameListView.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import UIKit
import RxSwift
import RxRelay

final class GameListView: UIStackView {

    private let numberListRelay = PublishRelay<[[Int]]>()
    private var disposeBag = DisposeBag()
    
    private var AGame = GameView(gameName: "A 게임")
    private var BGame = GameView(gameName: "B 게임")
    private var CGame = GameView(gameName: "C 게임")
    private var DGame = GameView(gameName: "D 게임")
    private var EGame = GameView(gameName: "E 게임")

    private var gameList: [GameView] = []
    
    init() {
        super.init(frame: .zero)
        
        initAttributes()
        initConstraints()
        bind()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setGame(numberList: [[Int]]) {
        numberListRelay.accept(numberList)
    }
    
    private func bind() {
        numberListRelay
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { view, numberLists in
                view.gameList.enumerated().forEach {
                    let game = $0
                    game.element.hideGame()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05 * Double($0.offset)) {
                        game.element.showGame()
                        game.element.bind(numberList: numberLists[game.offset])
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func initAttributes() {
        backgroundColor = .clear
        axis = .vertical
        distribution = .fill
        alignment = .leading
        spacing = 20
        autoresizingMask = .flexibleHeight
        
        gameList = [AGame, BGame, CGame, DGame, EGame]
        
        gameList.forEach {
            $0.hideGame()
        }
    }
    
    private func initConstraints() {
        [AGame, BGame, CGame, DGame, EGame].forEach {
            self.addArrangedSubview($0)
        }
    }
    
}
