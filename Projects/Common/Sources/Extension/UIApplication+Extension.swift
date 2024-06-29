//
//  UIApplication+Extension.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/13.
//

import UIKit

public extension UIApplication {
    
    static let myKeyWindow = UIApplication.shared.connectedScenes
        .filter({$0.activationState == .foregroundActive})
        .compactMap({$0 as? UIWindowScene})
        .first?.windows
        .filter({$0.isKeyWindow}).first
    
    public func keyWindowVC(vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return self.keyWindowVC(vc: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return self.keyWindowVC(vc: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return self.keyWindowVC(vc: pvc)
            } else {
                return vc
            }
        }
    }
    
}
