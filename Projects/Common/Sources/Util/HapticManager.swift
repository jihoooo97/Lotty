//
//  HapticManager.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/13.
//

import UIKit

public final class HapticManager {
    
    public static let shared = HapticManager()
    
    // warning, error, success
    public func hapticNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    // heavy, light, meduium, rigid, soft
    public func hapticImpact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
}
