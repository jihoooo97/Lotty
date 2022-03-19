import UIKit

class AlertView: UIView {
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 1
        
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
        
        view.addSubview(explainLabel)
        view.addSubview(confirmButton)
        
        return view
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
        
        
//        addSubview(mapImage)
        
        commonConstraint()
    }
    
    func commonConstraint() {
//        mapImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        mapImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//        mapImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        mapImage.heightAnchor.constraint(equalToConstant: 100).isActive = true
//
//        explainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
//        explainLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
//        explainLabel.topAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
//
//        confirmButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        confirmButton.topAnchor.constraint(equalTo: explainLabel.bottomAnchor, constant: 20).isActive = true
//        confirmButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        confirmButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}
