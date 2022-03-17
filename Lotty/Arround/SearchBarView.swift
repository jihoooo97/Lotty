import UIKit

class SearchBarView: UIButton {
    let scopeImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "find_icon")
        imageView.tintColor = .G400
        return imageView
    }()
    let searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.textColor = .G400
        label.text = "위치 검색"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 19)
        return label
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
        layer.cornerRadius = 4
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 1
        
        addSubview(scopeImage)
        scopeImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        scopeImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        scopeImage.widthAnchor.constraint(equalToConstant: 20).isActive = true
        scopeImage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        addSubview(searchLabel)
        searchLabel.leadingAnchor.constraint(equalTo: scopeImage.trailingAnchor, constant: 16).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
