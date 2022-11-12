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
    
    let drawNumberRelay = PublishRelay<String>()
    let publishDayRelay = PublishRelay<String>()
    let drawingDayRelay = PublishRelay<String>()
    let dueDayRelay = PublishRelay<String>()
    
    let lotteryNumberListRelay = PublishRelay<[[Int]]>()
    
    // MARK: 로또 회차
    func getDrawNumber() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko")
        
        let base = 1002
        let origin = Date()
        let now = formatter.string(from: origin)
        
        guard let startTime = formatter.date(from: "2022-02-12 20:45:00") else { return 0 }
        guard let endTime = formatter.date(from: now) else { return 0 }
        
        let subTime = Int(endTime.timeIntervalSince(startTime)) / 60
        let count = subTime / 10080
        
        drawNumberRelay.accept(String(base + count))
        return base + count
    }
    
    // MARK: 로또 발행일
    func getPublishDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd (E) kk:mm:ss"
        formatter.locale = Locale(identifier: "ko")
        
        let now = Date()
        let time = formatter.string(from: now)
        publishDayRelay.accept(time)
    }
    
    // MARK: 로또 추첨일, 지급기한
    func getDrawDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd (E) HH:mm:ss"
        formatter.locale = Locale(identifier: "ko")
        
        guard let start = formatter.date(from: "2022/03/05 (토) 20:45:00") else { return }
        
        let addTime = start.addingTimeInterval(TimeInterval((getDrawNumber() - 1004) * 86400 * 7))
        let drawDay = formatter.string(from: addTime)
        drawingDayRelay.accept(drawDay)
    }
    
    func getDueDay() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd (E)"
        formatter.locale = Locale(identifier: "ko")
        
        guard let start = formatter.date(from: "2022/03/05 (토)") else { return }
        
        let addTime = start.addingTimeInterval(TimeInterval(((getDrawNumber() - 1004) * 7 + 364) * 86400))
        let dueDay = formatter.string(from: addTime)
        dueDayRelay.accept(dueDay)
    }
    
    // MARK: 로또 번호 생성
    func setNumber() {
        var randomList: [[Int]] = []
        for _ in 0...4 {
            var randomNo: [Int] = []
            for _ in 0...6 {
                var drwtNo = Int.random(in: 1...45)
                while randomNo.contains(drwtNo) {
                    drwtNo = Int.random(in: 1...45)
                }
                randomNo.append(drwtNo)
            }
            randomNo.sort()
            randomList.append(randomNo)
        }
        lotteryNumberListRelay.accept(randomList)
    }
    
}
