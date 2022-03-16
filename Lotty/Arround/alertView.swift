import UIKit

class alertView: UIView {
    let mapImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage()
        return imageView
    }()
    
    let explainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "일일 검색량을 초과했습니다 kakaomap에서 계속 검색해주세요"
        label.font = UIFont(name: "Pretendard-Bold", size: 15)
        label.textColor = .white
        return label
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        button.titleLabel?.textColor = .white
        button.tintColor = .B600
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
        self.backgroundColor = .black
        self.alpha = 0.3
        
        addSubview(mapImage)
        addSubview(explainLabel)
        addSubview(confirmButton)
        commonConstraint()
    }
    
    func commonConstraint() {
        mapImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        mapImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        mapImage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        mapImage.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
