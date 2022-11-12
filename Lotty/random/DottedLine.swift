import UIKit

class DottedLine: UIView {
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let pattern: [CGFloat] = [9, 6]
        path.lineWidth = 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.setLineDash(pattern, count: pattern.count, phase: 0)
        LottyColors.G900.set()
        
        path.stroke()
    }
}
