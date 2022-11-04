import UIKit

class GameView: UIView {
    var multipleAttributes = [NSAttributedString.Key : Any]()
    
    let GameName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "A 게임"
        label.textColor = .G900
        label.font = UIFont(name: "BMDoHyeon", size: 14)
        return label
    }()
    let No1: CountLabel = {
        let label = CountLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "45"
        label.textColor = .G900
        label.font = UIFont(name: "BMDoHyeon", size: 14)
        return label
    }()
    let No2: CountLabel = {
        let label = CountLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "45"
        label.textColor = .G900
        label.font = UIFont(name: "BMDoHyeon", size: 14)
        return label
    }()
    let No3: CountLabel = {
        let label = CountLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "45"
        label.textColor = .G900
        label.font = UIFont(name: "BMDoHyeon", size: 14)
        return label
    }()
    let No4: CountLabel = {
        let label = CountLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "45"
        label.textColor = .G900
        label.font = UIFont(name: "BMDoHyeon", size: 14)
        return label
    }()
    let No5: CountLabel = {
        let label = CountLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "45"
        label.textColor = .G900
        label.font = UIFont(name: "BMDoHyeon", size: 14)
        return label
    }()
    let No6: CountLabel = {
        let label = CountLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "45"
        label.textColor = .G900
        label.font = UIFont(name: "BMDoHyeon", size: 15)
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
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        
        addSubview(GameName)
        addSubview(No1)
        addSubview(No2)
        addSubview(No3)
        addSubview(No4)
        addSubview(No5)
        addSubview(No6)
        commonConstraint()
    }
    
    func commonConstraint() {
        GameName.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        GameName.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        No1.leadingAnchor.constraint(equalTo: GameName.trailingAnchor, constant: 30).isActive = true
        No1.centerYAnchor.constraint(equalTo: GameName.centerYAnchor).isActive = true
        
        No2.leadingAnchor.constraint(equalTo: No1.trailingAnchor, constant: 40).isActive = true
        No2.centerYAnchor.constraint(equalTo: No1.centerYAnchor).isActive = true
        
        No3.leadingAnchor.constraint(equalTo: No2.trailingAnchor, constant: 40).isActive = true
        No3.centerYAnchor.constraint(equalTo: No2.centerYAnchor).isActive = true
        
        No4.leadingAnchor.constraint(equalTo: No3.trailingAnchor, constant: 40).isActive = true
        No4.centerYAnchor.constraint(equalTo: No3.centerYAnchor).isActive = true
        
        No5.leadingAnchor.constraint(equalTo: No4.trailingAnchor, constant: 40).isActive = true
        No5.centerYAnchor.constraint(equalTo: No4.centerYAnchor).isActive = true
        
        No6.leadingAnchor.constraint(equalTo: No5.trailingAnchor, constant: 40).isActive = true
        No6.centerYAnchor.constraint(equalTo: No5.centerYAnchor).isActive = true
    }
}
