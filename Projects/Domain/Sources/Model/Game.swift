//
//  Game.swift
//  Lotty
//
//  Created by 유지호 on 2023/04/21.
//

import Foundation

public struct Game {
    public var turn: Int
    public var publishDay: String
    public var drawingDay: String
    public var dueDay: String
    public var numberList: [[Int]]
    
    public init(
        turn: Int,
        publishDay: String,
        drawingDay: String,
        dueDay: String,
        numberList: [[Int]]
    ) {
        self.turn = turn
        self.publishDay = publishDay
        self.drawingDay = drawingDay
        self.dueDay = dueDay
        self.numberList = numberList
    }
}
