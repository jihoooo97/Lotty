import UIKit

class RightLine: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setLabel()
    }
    
    func setLabel() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.height, height: 30)
        self.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        self.text = "로또의 민족                              로또의 민족                              로또의 민족                              로또의 민족                         로또의 민족          "
        self.textColor = .white
        self.backgroundColor = .B600
        self.alpha = 0.5
    }
}
