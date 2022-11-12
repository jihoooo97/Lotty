import UIKit

class DottedLine: UIView {
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        let pattern: [CGFloat] = [9, 6]
        path.lineWidth = 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: frame.maxX, y: 0))
        path.setLineDash(pattern, count: pattern.count, phase: 0)
        LottyColors.G900.set()
        
        path.stroke()
    }
    
    func addDashedBorder() {
        backgroundColor = .white
        
        let path = UIBezierPath()
        
        path.lineWidth = 2
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: bounds.width, y: 0))
        path.stroke()
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = path.lineWidth
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = LottyColors.G900.cgColor
        shapeLayer.lineDashPattern = [9, 6]
        layer.addSublayer(shapeLayer)
    }
    
}
