import UIKit

class SideButton: UIView {
    let currentLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("현위치", for: .normal)
        button.titleLabel?.textColor = .B500
        button.backgroundColor = .white
        button.layer.cornerRadius = 4
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.2
        
        addSubview(currentLocationButton)
        commonConstraint()
    }
    
    func commonConstraint() {
        currentLocationButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        currentLocationButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        currentLocationButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        currentLocationButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    }
}
