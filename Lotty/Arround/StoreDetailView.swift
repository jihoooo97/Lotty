import UIKit

class StoreDetailView: UIView {
    var lat = ""
    var lng = ""
    
    let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        view.layer.shadowOpacity = 0.4
        view.layer.shadowRadius = 1
        return view
    }()
    
    let storeName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "가게 이름"
        label.textColor = .G900
        return label
    }()
    
    let storeAddress: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "가게 주소"
        label.textColor = .G300
        label.numberOfLines = 2
        return label
    }()
    
    let storeCall: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "가게 전화번호"
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
        addSubview(backgroundView)
        backgroundView.addSubview(storeName)
        backgroundView.addSubview(storeAddress)
        backgroundView.addSubview(storeCall)
        backgroundView.addSubview(naviButton)
        commonConstraint()
    }
    
    func commonConstraint() {
        // 컨텐츠 프레임
        backgroundView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        backgroundView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        
        // 가게 이름
        storeName.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 8).isActive = true
        storeName.trailingAnchor.constraint(equalTo: naviButton.leadingAnchor, constant: 8).isActive = true
        storeName.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16).isActive = true
        
        // 가게 주소
        storeAddress.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 8).isActive = true
        storeAddress.trailingAnchor.constraint(equalTo: naviButton.leadingAnchor, constant: -8).isActive = true
        storeAddress.topAnchor.constraint(equalTo: storeName.bottomAnchor, constant: 2).isActive = true
        
        // 가게 연락처
        storeCall.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 8).isActive = true
        storeCall.trailingAnchor.constraint(equalTo: naviButton.leadingAnchor, constant: -8).isActive = true
        storeCall.topAnchor.constraint(equalTo: storeAddress.bottomAnchor, constant: 2).isActive = true
        
        // 길찾기 버튼
        naviButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        naviButton.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -8).isActive = true
        naviButton.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 15).isActive = true
        naviButton.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -15).isActive = true
    }
}
