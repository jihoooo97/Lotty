//
//  AlertManager.swift
//  Lotty
//
//  Created by JihoMac on 2022/11/13.
//

import UIKit

final class AlertManager: NSObject {

    static let shared = AlertManager()
    
    private override init() { }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(
            title: "확인",
            style: .default
        ) { (action) in
            UIApplication.myKeyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(confirm)
        UIApplication.myKeyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    // 네트워크 연결 에러 토스트
    func showNetworkErrorAlert() {
        let alert = UIAlertController(
            title: "오류",
            message: "네트워크 연결을 확인해주세요",
            preferredStyle: .alert
        )
        let confirm = UIAlertAction(
            title: "확인",
            style: .default
        ) { (action) in
            UIApplication.myKeyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
        }
        alert.addAction(confirm)
        UIApplication.myKeyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}
