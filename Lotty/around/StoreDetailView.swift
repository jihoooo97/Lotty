import UIKit

class StoreDetailView: UIView {
    var id = ""
    var lat = ""
    var lng = ""
    
    let storeName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "가게 이름"
        label.font = UIFont(name: "Pretendard-SemiBold", size: 17)
        label.textColor = LottyColors.G900
        return label
    }()
    
    let storeAddress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "가게 주소"
        label.font = UIFont(name: "Pretendard-Regular", size: 15)
        label.textColor = LottyColors.G500
        label.numberOfLines = 2
        return label
    }()
    
    let storeCall: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "가게 전화번호"
        label.font = UIFont(name: "Pretendard-Regular", size: 15)
        label.textColor = LottyColors.B500
        return label
    }()
    
    let naviView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = LottyColors.B600
        view.layer.cornerRadius = 4
 
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "navigation_icon")
        imageView.tintColor = .white

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "길찾기"
        label.font = UIFont(name: "Pretendard-Regular", size: 15)
        label.textColor = .white
        
        view.addSubview(imageView)
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true

        view.addSubview(label)
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 2).isActive = true
        label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        
        return view
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
        layer.cornerRadius = 4
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 1
        
        addSubview(storeName)
        addSubview(storeAddress)
        addSubview(storeCall)
        addSubview(naviView)
        commonConstraint()
    }
    
    func commonConstraint() {
        // 가게 이름
        storeName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        storeName.trailingAnchor.constraint(equalTo: naviView.leadingAnchor, constant: 4).isActive = true
        storeName.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        
        // 가게 주소
        storeAddress.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        storeAddress.trailingAnchor.constraint(equalTo: naviView.leadingAnchor, constant: -2).isActive = true
        storeAddress.topAnchor.constraint(equalTo: storeName.bottomAnchor, constant: 12).isActive = true
        
        // 가게 연락처
        storeCall.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        storeCall.trailingAnchor.constraint(equalTo: naviView.leadingAnchor, constant: -8).isActive = true
        storeCall.topAnchor.constraint(equalTo: storeAddress.bottomAnchor, constant: 8).isActive = true
        storeCall.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive = true
        
        // 길찾기 버튼
        naviView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        naviView.topAnchor.constraint(equalTo: self.topAnchor, constant: 12).isActive = true
        naviView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        naviView.widthAnchor.constraint(equalTo: naviView.heightAnchor).isActive = true
    }
}
