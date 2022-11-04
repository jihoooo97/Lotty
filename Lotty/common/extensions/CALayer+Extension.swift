import UIKit

extension CALayer {
    
    func applyShadow(
        color: UIColor = .black,
        x: CGFloat = 0,
        y: CGFloat = 0,
        alpha: Float = 0.5,
        blur: CGFloat = 4
    ) {
        shadowColor = color.cgColor
        shadowOffset = CGSize(width: x, height: y)
        shadowOpacity = alpha
        shadowRadius = blur / 2.0
    }
    
}
