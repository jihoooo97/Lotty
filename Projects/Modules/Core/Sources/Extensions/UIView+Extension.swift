import UIKit

public extension UIView {
    
    func addSubViews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
    
    func applyShadow(
        color: UIColor = .black,
        x: CGFloat = 0,
        y: CGFloat = 0,
        alpha: Float = 0.5,
        blur: CGFloat = 4
    ) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: x, height: y)
        self.layer.shadowOpacity = alpha
        self.layer.shadowRadius = blur / 2.0
    }
    
    func border(
        _ color: UIColor = .white,
        width: CGFloat = 1.0,
        radius: CGFloat = 16.0
    ) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.layer.cornerRadius = radius
    }
    
}
