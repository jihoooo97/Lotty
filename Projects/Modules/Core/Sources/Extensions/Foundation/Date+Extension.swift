//
//  Date+Extension.swift
//  Core
//
//  Created by 유지호 on 6/15/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Foundation

public extension Date {
    
    // MARK: Full Date
    
    static var fullDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter
    }
    
    func fullDateString() -> String {
        return Self.fullDateFormatter.string(from: self)
    }
    
    static func fullDate(from date: String) -> Date? {
        return Self.fullDateFormatter.date(from: date)
    }
    
    
    
    // MARK: Year Month Day
    
    static var yearMonthDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    func yearMonthDayString() -> String {
        return Self.yearMonthDayFormatter.string(from: self)
    }
    
    static func yearMonthDayDate(from date: String) -> Date? {
        return Self.yearMonthDayFormatter.date(from: date)
    }
    
    
    
    // MARK: Month Day
    
    static var monthDayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        return formatter
    }
    
    func monthDayString() -> String {
        return Self.monthDayFormatter.string(from: self)
    }
    
    static func monthDayDate(from date: String) -> Date? {
        return Self.monthDayFormatter.date(from: date)
    }
    
}
