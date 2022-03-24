import UIKit

class RightLine: UIView {
    let contentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "          로또의 민족                                                              로또의 민족                                                         로또의 민족          "
        label.textColor = .white
        label.font = UIFont(name: "BM DoHyeon", size: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    func commonInit() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        self.backgroundColor = .B600
        self.alpha = 0.5
        
        addSubview(contentLabel)
        commonConstraint()
    }
    
    func commonConstraint() {
        contentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
}
