import UIKit
import CommonUI

class LottyMapMarker: BaseMapMarker {

    let markerImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                  width: 50, height: 50))
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initUI() {
        self.addSubview(markerImage)
    }
    
    override func setState() {
        if isPressed {
            markerImage.image = UIImage(named: "clover_four_icon")!.resize(width: 50)
        } else {
            markerImage.image = UIImage(named: "clover_three_icon")!.resize(width: 50)
        }
    }
    
}
