import UIKit

class AlertView: UIView {
    let mapImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "bubble_talk_icon")
        return imageView
    }()
    
    let explainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.sizeToFit()
        label.text = "일일 검색량을 초과했습니다 kakaomap에서 계속 검색해주세요"
        label.font = UIFont(name: "Pretendard-Bold", size: 15)
        label.textColor = .G900
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        button.titleLabel?.textColor = .G900
        button.tintColor = .B600
        button.layer.cornerRadius = 4
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.G300.cgColor
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
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .white
        self.layer.cornerRadius = 16
        
//        addSubview(mapImage)
        addSubview(explainLabel)
        addSubview(confirmButton)
        commonConstraint()
    }
    
    func commonConstraint() {
//        mapImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        mapImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        mapImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        mapImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
        explainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        explainLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        explainLabel.topAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        confirmButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        confirmButton.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: 20).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
