import UIKit

class BaseMapMarker: UIView {

    public var isPressed: Bool = false {
        didSet {
            setState()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setState() { }
    
}
