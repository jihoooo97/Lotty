//
//  RandomViewModel.swift
//  Lotty
//
//  Created by JihoMac on 2022/04/17.
//

import Foundation
import RxSwift
import RxRelay

final class RandomViewModel: BaseViewModel {
    
    private let usecase: GameUsecaseProtocol
    
    // MARK: Input
    let tapCreateLotteryButtonRelay = PublishRelay<Void>()
    
    // MARK: Output
    let gameRelay = PublishRelay<Game>()
    
    
    init(usecase: GameUsecaseProtocol) {
        self.usecase = usecase
        super.init()
        
        tapCreateLotteryButtonRelay
            .withUnretained(self).map { $0.0 }
            .bind { vm in
                let game = Game(
                    turn: vm.getTurn(),
                    publishDay: vm.getPublishDay(),
                    drawingDay: vm.getDrawDay(),
                    dueDay: vm.getDueDay(),
                    numberList: vm.getNumberList()
                )
                vm.gameRelay.accept(game)
            }
            .disposed(by: disposeBag)
    }
    
    
    // MARK: 로또 회차
    private func getTurn() -> Int {
        return usecase.getTurn()
    }
    
    // MARK: 로또 발행일
    private func getPublishDay() -> String {
        return usecase.getPublishDay()
    }
    
    // MARK: 로또 추첨일, 지급기한
    private func getDrawDay() -> String {
        return usecase.getDrawDay()
    }
    
    private func getDueDay() -> String {
        return usecase.getDueDay()
    }
    
    // MARK: 로또 번호 생성
    private func getNumberList() -> [[Int]] {
        return usecase.getNumberList()
    }

}
