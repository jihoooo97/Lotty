import UIKit

class SideButton: UIView {
    let currentLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("내위치", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 15)
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
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 2
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 1
        
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
