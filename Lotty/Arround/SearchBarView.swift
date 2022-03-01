import UIKit

class SearchBarView: UIButton {
    let searchLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.textColor = .G900
        label.text = "위치 검색"
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
        layer.cornerRadius = 8
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.2
        
        addSubview(searchLabel)
        searchLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
