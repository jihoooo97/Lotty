import UIKit

class BackgroundLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLabel()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setLabel()
    }
    
    func setLabel() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.sizeToFit()
        self.textColor = LottyColors.B600
        self.alpha = 0.5
    }
}
