import UIKit

class RefreshView: UIView {
    let imgArray: [UIImage] = [
        UIImage(named: "coin_icon")!
    ]
    
    let refreshImage: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        img.image = UIImage(named: "coin_icon")
        return img
    }()
    
    let refreshText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "땡겨요"
        label.textColor = .white
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
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        addSubview(refreshImage)
        addSubview(refreshText)
        refreshImage.image = resizeImage(image: refreshImage.image!, newWidth: 30)
        commonConstraint()
    }
    
    func commonConstraint() {
        refreshText.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        refreshText.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        refreshImage.trailingAnchor.constraint(equalTo: refreshText.leadingAnchor, constant: -4).isActive = true
        refreshImage.centerYAnchor.constraint(equalTo: refreshText.centerYAnchor).isActive = true
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        image.draw(in: CGRect(origin: .zero, size: CGSize(width: newWidth, height: newWidth)))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    func imgCATransition(_ img: UIImageView, down: Bool) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = .init(name: .easeInEaseOut)
        transition.type = .push
        if down { transition.subtype = .fromTop }
        else { transition.subtype = .fromBottom }
        img.layer.add(transition, forKey: CATransitionType.push.rawValue)
    }
}
