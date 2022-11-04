import UIKit

extension BaseMapMarker {
    
    // UIView to UIImage
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: frame.size)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }
    
}
