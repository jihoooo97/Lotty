//
//  RotationLabel.swift
//  RandomFeature
//
//  Created by 유지호 on 6/24/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import Core

import UIKit


public final class RotationLabel: UIView {
    
    private let scrollLayer = CAScrollLayer()
    
    private var scrollLabels: [UILabel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.addSublayer(scrollLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        scrollLayer.frame = self.bounds
    }
    
    
    public func configure(with number: Int) {
        clear()
        createContentForLayer(text: "\(number)")
        createAnimation()
    }
    
    private func createContentForLayer(text: String) {
        var textsForScroll: [String] = (0...9).map { _ in
            "\(Int.random(in: 1...45))"
        }
        
        textsForScroll.append(text)
        
        for (offset, text) in textsForScroll.enumerated() {
            let label = createLabel(text: text)
            label.frame = .init(
                origin: .init(x: 0, y: CGFloat(offset) * scrollLayer.frame.height),
                size: scrollLayer.frame.size
            )
            
            scrollLayer.addSublayer(label.layer)
            scrollLabels.append(label)
        }
    }
    
    private func createAnimation(ascending: Bool = true) {
        let maxY = scrollLayer.sublayers?.last?.frame.origin.y ?? 0.0
        
        let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
        animation.duration = 0.7
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.fromValue = ascending ? maxY : 0.0
        animation.toValue = ascending ? 0.0 : maxY
        
        scrollLayer.scrollMode = .vertically
        scrollLayer.add(animation, forKey: nil)
        scrollLayer.scroll(to: CGPoint(x: 0, y: maxY))
    }
    
    private func createLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .monospacedSystemFont(ofSize: 16.0, weight: .bold)
        label.textAlignment = .center
        return label
    }
    
    private func clear() {
        scrollLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        scrollLabels.removeAll()
    }
    
}
