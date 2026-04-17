//
//  ViewModelable.swift
//  BaseFeature
//
//  Created by 유지호 on 6/15/25.
//  Copyright © 2025 Lotty. All rights reserved.
//


public protocol ViewModelable {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input) -> Output
}