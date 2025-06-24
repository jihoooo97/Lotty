//
//  DottedLine.swift
//  UIComponent
//
//  Created by 유지호 on 6/24/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core

import UIKit

public final class DottedLine: UIView {
    
    private let dotColor: UIColor
    private let dotWidth: CGFloat
    
    public init(_ color: UIColor = .systemBackground, width: CGFloat) {
        self.dotColor = color
        self.dotWidth = width
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.lineWidth = dotWidth
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.frame.maxX, y: 0))
        
        let pattern: [CGFloat] = [9, 6]
        path.setLineDash(pattern, count: pattern.count, phase: 0)
        dotColor.set()
        
        path.stroke()
    }
    
    
}
