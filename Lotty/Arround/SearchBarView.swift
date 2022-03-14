import UIKit

class SearchBarView: UIButton {
    let searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.textColor = .G900
        label.text = "위치 검색"
        label.font = UIFont(name: "Pretendard-Medium", size: 17)
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
        
        addSubview(searchLabel)
        searchLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
