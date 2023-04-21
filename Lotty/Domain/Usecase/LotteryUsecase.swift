//
//  LotteryUsecase.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/16.
//

import Foundation

protocol LotteryUsecaseProtocol {
    func getLottery(turn: Int, completion: @escaping(Result<Lottery, Error>) -> Void)
    func getLotteryList(turn: Int, recent: Int, completion: @escaping(Result<[Lottery], Error>) -> Void)
    func getMoreLotteryList(turn: Int, completion: @escaping(Result<[Lottery], Error>) -> Void)
}

final class LotteryUsecase: LotteryUsecaseProtocol {

    private let repository: LotteryRepositoryProtocol
    
    init(repository: LotteryRepositoryProtocol) {
        self.repository = repository
    }
    
    // 단일 로또
    func getLottery(
        turn: Int,
        completion: @escaping(Result<Lottery, Error>) -> Void
    ) {
        repository.getLottery(turn: turn) { result in
            switch result {
            case .success(let lottery):
                completion(.success(lottery))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 로또 리스트
    func getLotteryList(
        turn: Int,
        recent: Int,
        completion: @escaping(Result<[Lottery], Error>) -> Void
    ) {
        var lotteryList: [Lottery] = []
        
        for i in 0..<10 {
            repository.getLottery(turn: turn - i) { result in
                switch result {
                case .success(let lottery):
                    if lottery.turn == recent {
                        var recentLottery = lottery
                        recentLottery.isOpen = true
                        lotteryList.append(recentLottery)
                    } else {
                        lotteryList.append(lottery)
                    }
                    
                    if lotteryList.count > 9 {
                        completion(.success(lotteryList.sorted(by: { $0.turn > $1.turn })))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getMoreLotteryList(
        turn: Int,
        completion: @escaping(Result<[Lottery], Error>) -> Void
    ) {
        var lotteryList: [Lottery] = []
        var isEnd = false
        
        for i in 0..<10 {
            let currentTurn = turn - i

            // 회차가 1회차 미만이면 return
            if currentTurn < 1 {
                isEnd = true
                return
            }
            
            repository.getLottery(turn: turn - i) { result in
                switch result {
                case .success(let lottery):
                    lotteryList.append(lottery)
                    
                    if lotteryList.count > 9 {
                        isEnd = true
                    }
                    
                    if isEnd {
                        completion(.success(lotteryList.sorted(by: { $0.turn > $1.turn })))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }

}
