import UIKit

extension UIImage {
    
    func resize(width: CGFloat) -> UIImage {
        let scale = width / self.size.width
        let height = self.size.height * scale
        
        let size = CGSize(width: width, height: height)
        let render = UIGraphicsImageRenderer(size: size)
        let renderImage = render.image { context in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return renderImage
    }
    
}
