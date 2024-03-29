import UIKit

extension AroundViewController {
    
    func configureAlertView() {
        blockView.translatesAutoresizingMaskIntoConstraints = false
        blockView.backgroundColor = .black
        blockView.alpha = 0.6
        
        view.addSubview(blockView)
        blockView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blockView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        blockView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blockView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(alertView)
        alertView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        alertView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        alertView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 200).isActive = true
        alertView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        alertView.confirmButton.addTarget(self, action: #selector(popAlert), for: .touchUpInside)
    }
    
    @objc func popAlert() {
        self.alertView.confirmButton.isEnabled = false
        DispatchQueue.main.async {
            self.alertView.removeFromSuperview()
            self.blockView.removeFromSuperview()
        }
        let url = "kakaomap://"
        if let openApp = URL(string: url), UIApplication.shared.canOpenURL(openApp) {
            UIApplication.shared.open(openApp)
        } else {
            let downApp = URL(string: "https://apps.apple.com/us/app/id304608425")!
            UIApplication.shared.open(downApp)
        }
    }
    
}
