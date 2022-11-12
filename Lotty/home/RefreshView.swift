import UIKit

class RefreshView: UIView {
    var fullText = ""
    
    private var scrollLayers: [CAScrollLayer] = []
    private var scrollImages: [UIView] = []
    
    private let duration = 0.7
    private let durationOffset = 0.2
    
    private let textsNotAnimated = [","]
    
    let imgArray: [UIImage] = [
        UIImage(named: "coin_icon")!,
        UIImage(named: "car_icon")!,
        UIImage(named: "clover_icon")!,
        UIImage(named: "dollar_icon")!,
        UIImage(named: "house_icon")!,
        UIImage(named: "jewel_icon")!,
        UIImage(named: "luckybag_icon")!,
        UIImage(named: "pig_icon")!,
        UIImage(named: "rocket_icon")!
    ]
    let refreshImage = UIImageView()
    
    let randomNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "00"
        label.textColor = LottyColors.B500
        return label
    }()
    
    let refreshText: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.sizeToFit()
        label.text = "뽑아요"
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
        
        refreshImage.translatesAutoresizingMaskIntoConstraints = false
        refreshImage.image = imgArray.randomElement()
        refreshImage.contentMode = .scaleAspectFit
        
        addSubview(refreshImage)
        addSubview(randomNumber)
        addSubview(refreshText)
        refreshImage.image = resizeImage(image: refreshImage.image!, newWidth: 30)
        commonConstraint()
    }
    
    func commonConstraint() {
        refreshText.leadingAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        refreshText.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        refreshImage.trailingAnchor.constraint(equalTo: refreshText.leadingAnchor, constant: -4).isActive = true
        refreshImage.centerYAnchor.constraint(equalTo: refreshText.centerYAnchor).isActive = true
        
        randomNumber.centerXAnchor.constraint(equalTo: refreshImage.centerXAnchor).isActive = true
        randomNumber.centerYAnchor.constraint(equalTo: refreshImage.centerYAnchor).isActive = true
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newWidth))
        image.draw(in: CGRect(origin: .zero, size: CGSize(width: newWidth, height: newWidth)))
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resultImage
    }
    
    func imgCATransition(_ img: UIImageView, down: Bool) {
        refreshImage.image = resizeImage(image: imgArray.randomElement()!, newWidth: 30)
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = .init(name: .easeInEaseOut)
        transition.type = .push
        if down { transition.subtype = .fromTop }
        else { transition.subtype = .fromBottom }
        img.layer.add(transition, forKey: CATransitionType.push.rawValue)
    }
    
    func configure(with number: Int) {
        fullText = String(number)
        clean()
        setupSubviews()
    }
    
    private func clean() {
        randomNumber.subviews.forEach { $0.removeFromSuperview() }
        randomNumber.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        scrollLayers.removeAll()
        scrollImages.removeAll()
    }
    
    func animate(ascending: Bool = true) {
        createAnimations(ascending: ascending)
    }
    
    private func setupSubviews() {
        let label = UILabel()
        label.frame.origin = CGPoint(x: 0, y: 0)
        label.textColor = LottyColors.G900
        label.text = "0"
        label.sizeToFit()
        label.textAlignment = .center
        createScrollLayer(to: label, text: fullText)
    }
    
    private func createScrollLayer(to label: UILabel, text: String) {
        let scrollLayer = CAScrollLayer()
        scrollLayer.frame = label.frame
        scrollLayers.append(scrollLayer)
        randomNumber.layer.addSublayer(scrollLayer)
        
        createContentForLayer(scrollLayer: scrollLayer, text: text)
    }
    
    private func createContentForLayer(scrollLayer: CAScrollLayer, text: String) {
//        var textsForScroll: [UIImage] = []
        scrollLayer.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        textsForScroll.append("0")
//        for _ in 0...9 {
//            textsForScroll.append(String(Int.random(in: 1...45)))
//        }
//        textsForScroll.append(text)
        
        var height: CGFloat = 0
//        for text in textsForScroll {
//            let label = UILabel()
//            label.text = text
//            label.textColor = .G900
//            label.sizeToFit()
//            label.textAlignment = .center
//            label.frame = CGRect(x: 0, y: height, width: scrollLayer.frame.width, height: scrollLayer.frame.height)
//            scrollLayer.addSublayer(label.layer)
//            scrollLabels.append(label)
//            height = label.frame.maxY
//        }
        for img in imgArray {
            let imageView = UIImageView()
            imageView.image = img
            imageView.frame = CGRect(x: 0, y: height, width: scrollLayer.frame.width, height: scrollLayer.frame.height)
            scrollLayer.addSublayer(imageView.layer)
            scrollImages.append(imageView)
            height = imageView.frame.maxY
        }
    }
    
    private func createAnimations(ascending: Bool) {
        var offset: CFTimeInterval = 0.0
        
        for scrollLayer in scrollLayers {
            let maxY = scrollLayer.sublayers?.last?.frame.origin.y ?? 0.0
            
            let animation = CABasicAnimation(keyPath: "sublayerTransform.translation.y")
            animation.duration = duration + offset
            animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
            
            if ascending {
                animation.fromValue = maxY
                animation.toValue = 0
            } else {
                animation.fromValue = 0
                animation.toValue = maxY
            }
            
            scrollLayer.scrollMode = .vertically
            // custom key 설정
            scrollLayer.add(animation, forKey: nil)
            scrollLayer.scroll(to: CGPoint(x: 0, y: maxY))
            
            offset += self.durationOffset
        }
    }
}
