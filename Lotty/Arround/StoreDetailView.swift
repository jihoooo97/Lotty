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
        label.font = UIFont(name: "Pretendard-Bold", size: 17)
        label.textColor = .G900
        return label
    }()
    
    let storeAddress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "가게 주소"
        label.font = UIFont(name: "Pretendard-Bold", size: 15)
        label.textColor = .G300
        label.numberOfLines = 2
        return label
    }()
    
    let storeCall: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "가게 전화번호"
        label.font = UIFont(name: "Pretendard-Bold", size: 15)
        label.textColor = .G900
        return label
    }()
    
    let naviButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: "navigation_icon"), for: .normal)
        button.backgroundColor = .B600
        button.tintColor = .white
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
        addSubview(storeName)
        addSubview(storeAddress)
        addSubview(storeCall)
        addSubview(naviButton)
        commonConstraint()
    }
    
    func commonConstraint() {
        // 가게 이름
        storeName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12).isActive = true
        storeName.trailingAnchor.constraint(equalTo: naviButton.leadingAnchor, constant: 4).isActive = true
        storeName.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        
        // 가게 주소
        storeAddress.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13).isActive = true
        storeAddress.trailingAnchor.constraint(equalTo: naviButton.leadingAnchor, constant: -2).isActive = true
        storeAddress.topAnchor.constraint(equalTo: storeName.bottomAnchor, constant: 2).isActive = true
        
        // 가게 연락처
        storeCall.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 13).isActive = true
        storeCall.trailingAnchor.constraint(equalTo: naviButton.leadingAnchor, constant: -8).isActive = true
        storeCall.topAnchor.constraint(equalTo: storeAddress.bottomAnchor, constant: 8).isActive = true
        
        // 길찾기 버튼
        naviButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        naviButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8).isActive = true
        naviButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        naviButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
    }
}
