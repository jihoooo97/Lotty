//
//  DrawViewModel.swift
//  RandomFeature
//
//  Created by 유지호 on 6/20/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import BaseFeature
import Core
import Domain

import Foundation
import RxSwift
import RxRelay

public final class DrawViewModel: ViewModelable {

    public struct Input {
        let drawButtonDidTap: Observable<Void>
    }
    
    public struct Output {
        let drawNo = PublishRelay<Int>()
        let publishingDate = PublishRelay<String>()
        let drawnDate = PublishRelay<String>()
        let dueDate = PublishRelay<String>()
        let winNoList = PublishRelay<[[Int]]>()
    }
    
    private let bag = DisposeBag()
    
    public init() { }
    
    
    public func transform(from input: Input) -> Output {
        let output = Output()
        
        input.drawButtonDidTap
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.instance)
            .withUnretained(self)
            .subscribe { owner, _ in
                HapticManager.run(style: .heavy)
                
                output.drawNo.accept(owner.setDrawNo())
                owner.setPublishingDate(with: output)
                output.drawnDate.accept(owner.drawnDateFormatter.string(from: owner.setDrawnDate()))
                output.dueDate.accept(owner.drawnDateFormatter.string(from: owner.setDueDate()))
                owner.setNumberList(with: output)
            }.disposed(by: bag)
        
        return output
    }
    
    // MARK: 로또 회차
    private func setDrawNo() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let timeZone = TimeZone(identifier: "Asia/Seoul")!
        
        var baseComponents = DateComponents()
        baseComponents.year = 2002
        baseComponents.month = 12
        baseComponents.day = 7
        baseComponents.hour = 20
        baseComponents.minute = 45
        baseComponents.timeZone = timeZone
        
        guard let baseDate = calendar.date(from: baseComponents) else { return 0 }
        
        let timeInterval = Date.now.timeIntervalSince(baseDate)
        let weekSeconds: TimeInterval = 604800
        let fullWeeksPassed = Int(timeInterval / weekSeconds)
        
        return 2 + fullWeeksPassed
    }
    
    // MARK: 로또 발행일
    public func setPublishingDate(with output: Output) {
        let publishingDate = drawnDateFormatter.string(from: Date.now)
        output.publishingDate.accept(publishingDate)
    }
    
    // MARK: 로또 추첨일
    public func setDrawnDate() -> Date {
        guard let baseDate = drawnDateFormatter.date(from: "2002/12/07 (토) 20:45:00") else {
            return .now
        }
        
        let timeInterval = TimeInterval((setDrawNo() - 1) * 604800)
        let drawnDate = baseDate.addingTimeInterval(timeInterval)
        return drawnDate
    }
    
    // MARK: 지급기한
    public func setDueDate() -> Date {
        guard let dueDate = Calendar.current.date(
            byAdding: .year,
            value: 1,
            to: setDrawnDate()
        ) else {
            return .now
        }
        
        return dueDate
    }
    
    // MARK: 로또 번호 생성
    public func setNumberList(with output: Output) {
        var winNoList: [[Int]] = []
        
        for _ in 0...4 {
            winNoList.append(drawLuckyNumber())
        }
        
        output.winNoList.accept(winNoList)
    }
    
    private func drawLuckyNumber() -> [Int] {
        var luckyNumbers: Set<Int> = []
        
        while luckyNumbers.count < 6 {
            let luckyNumber = (1...45).randomElement()!
            luckyNumbers.insert(luckyNumber)
        }
        
        return luckyNumbers.sorted(by: <)
    }
    
    private let drawnDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd (E) HH:mm:ss"
        formatter.locale = Locale(identifier: "ko")
        return formatter
    }()
    
    private let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd (E)"
        formatter.locale = Locale(identifier: "ko")
        return formatter
    }()
    
}
