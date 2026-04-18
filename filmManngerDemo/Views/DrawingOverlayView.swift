import UIKit

class DrawingOverlayView: UIView {
    var isDrawingEnabled = false {
        didSet {
            isUserInteractionEnabled = isDrawingEnabled
        }
    }

    private var currentPath: UIBezierPath?
    private var currentShapeLayer: CAShapeLayer?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func clear() {
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        currentPath = nil
        currentShapeLayer = nil
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawingEnabled, let touch = touches.first else { return }
        let point = touch.location(in: self)

        let path = UIBezierPath()
        path.move(to: point)
        currentPath = path

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1).cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 4
        shapeLayer.lineCap = .round
        shapeLayer.lineJoin = .round
        layer.addSublayer(shapeLayer)
        currentShapeLayer = shapeLayer
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawingEnabled, let touch = touches.first, let path = currentPath else { return }
        let point = touch.location(in: self)
        path.addLine(to: point)
        currentShapeLayer?.path = path.cgPath
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDrawingEnabled else { return }
        currentPath = nil
        currentShapeLayer = nil
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchesEnded(touches, with: event)
    }
}
