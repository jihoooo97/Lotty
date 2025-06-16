//
//  UIViewController+Extension.swift
//  Core
//
//  Created by 유지호 on 6/15/25.
//  Copyright © 2025 Lotty. All rights reserved.
//

import UIKit

public enum AlertType {
    case `default`
    case error
}

public extension UIViewController {
    
    func presentAlert(
        title: String = "알림",
        message: String? = nil,
        alertType: AlertType = .default,
        handler: ((UIAlertAction) -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(.init(
            title: "확인",
            style: .default,
            handler: handler
        ))
        
        if alertType == .default {
            alert.addAction(.init(
                title: "취소",
                style: .cancel,
                handler: { _ in
                    alert.dismiss(animated: true)
                })
            )
        }
        
        self.present(alert, animated: true)
    }
    
}
