import UIKit

class CountLabel: UILabel {
    var fullText = ""
    
    private var scrollLayers: [CAScrollLayer] = []
    private var scrollLabels: [UILabel] = []
    
    private let duration = 0.7
    private let durationOffset = 0.2
    
    private let textsNotAnimated = [","]
    
    func configure(with number: Int) {
        fullText = String(number)
        clean()
        setupSubviews()
    }
    
    func animate(ascending: Bool = true) {
        createAnimations(ascending: ascending)
    }
    
    private func clean() {
        self.text = " "
        self.textColor = .white
        self.subviews.forEach { $0.removeFromSuperview() }
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        scrollLayers.removeAll()
        scrollLabels.removeAll()
    }
    
    private func setupSubviews() {
        let label = UILabel()
        label.frame.origin = CGPoint(x: 0, y: 0)
        label.textColor = .G900
        label.font = UIFont(name: "BMDoHyeon", size: 14)
        label.text = "30"
        label.sizeToFit()
        label.textAlignment = .center
        
        createScrollLayer(to: label, text: fullText)
    }
    
    private func createScrollLayer(to label: UILabel, text: String) {
        let scrollLayer = CAScrollLayer()
        scrollLayer.frame = label.frame
        scrollLayers.append(scrollLayer)
        self.layer.addSublayer(scrollLayer)
        
        createContentForLayer(scrollLayer: scrollLayer, text: text)
    }
    
    private func createContentForLayer(scrollLayer: CAScrollLayer, text: String) {
        var textsForScroll: [String] = []
        
        scrollLayer.frame = CGRect(x: 0, y: 0, width: 24, height: frame.height)
        textsForScroll.append("00")
        for _ in 0...9 {
            textsForScroll.append(String(Int.random(in: 0...45)))
        }
        textsForScroll.append(text)
        
        var height: CGFloat = 20
        for text in textsForScroll {
            let label = UILabel()
            label.text = text
            label.textColor = .G900
            label.font = UIFont(name: "BMDoHyeon", size: 14)
            label.sizeToFit()
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: height, width: scrollLayer.frame.width, height: scrollLayer.frame.height)
            scrollLayer.addSublayer(label.layer)
            scrollLabels.append(label)
            height = label.frame.maxY
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
