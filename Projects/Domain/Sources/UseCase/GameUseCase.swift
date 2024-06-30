//
//  GameUseCase.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Foundation

public protocol GameUseCase {
    func getTurn() -> Int
    func getPublishDay() -> String
    func getDrawDay() -> String
    func getDueDay() -> String
    func getNumberList() -> [[Int]]
}

public final class GameUseCaseImpl: GameUseCase {

    public init() { }
    
    
    // MARK: 로또 회차
    public func getTurn() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko")
        
        let base = 1002
        let origin = Date()
        let now = formatter.string(from: origin)
        
        guard
            let startTime = formatter.date(from: "2022-02-12 20:45:00"),
            let endTime = formatter.date(from: now)
        else { return 0 }
        
        
        let subTime = Int(endTime.timeIntervalSince(startTime)) / 60
        let count = subTime / 10080
        
        return base + count + 1
    }
    
    // MARK: 로또 발행일
    public func getPublishDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd (E) kk:mm:ss"
        formatter.locale = Locale(identifier: "ko")
        
        let now = Date()
        let time = formatter.string(from: now)
        return time
    }
    
    // MARK: 로또 추첨일
    public func getDrawDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd (E) HH:mm:ss"
        formatter.locale = Locale(identifier: "ko")
        
        guard
            let start = formatter.date(from: "2022/03/05 (토) 20:45:00")
        else { return "----/--/-- (-) --:--:--" }
        
        let addTime = start.addingTimeInterval(TimeInterval((getTurn() - 1005) * 86400 * 7))
        let drawDay = formatter.string(from: addTime)
        return drawDay
    }
    
    // MARK: 지급기한
    public func getDueDay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd (E)"
        formatter.locale = Locale(identifier: "ko")
        
        guard
            let start = formatter.date(from: "2022/03/05 (토)")
        else { return "----/--/-- (-) --:--:--" }
        
        let addTime = start.addingTimeInterval(TimeInterval(((getTurn() - 1005) * 7 + 364) * 86400))
        let dueDay = formatter.string(from: addTime)
        return dueDay
    }
    
    // MARK: 로또 번호 생성
    public func getNumberList() -> [[Int]] {
        var randomList: [[Int]] = []
        for _ in 0...4 {
            randomList.append(getLuckyNumber())
        }
        return randomList
    }
    
    private func getLuckyNumber() -> [Int] {
        var luckyNumbers: Set<Int> = []
        
        while luckyNumbers.count < 6 {
            if let luckyNumber = (1...45).randomElement() {
                luckyNumbers.insert(luckyNumber)
            }
        }
        return luckyNumbers.sorted(by: <)
    }

}
