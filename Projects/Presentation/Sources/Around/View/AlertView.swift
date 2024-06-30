import UIKit
import CommonUI

class AlertView: UIView {
    let explainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.sizeToFit()
        label.text = "일일 검색량을 초과했습니다 kakaomap에서 계속 검색해주세요"
        label.textAlignment = .center
        label.font = UIFont(name: "Pretendard-Bold", size: 15)
        label.textColor = LottyColors.G900
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = LottyColors.B600
        button.layer.cornerRadius = 4
        return button
    }()
    
    let mapImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "bubble_talk_icon")
        return imageView
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
        layer.cornerRadius = 32
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 4
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 1
        
        addSubview(explainLabel)
        addSubview(confirmButton)
        commonConstraint()
    }
    
    func commonConstraint() {
        explainLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        explainLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 50).isActive = true
        explainLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        confirmButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        confirmButton.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: 20).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
