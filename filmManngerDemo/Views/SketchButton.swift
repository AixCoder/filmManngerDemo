import UIKit

class SketchButton: UIButton {
    enum Variant { case primary, secondary, danger }
    enum Size { case sm, md, lg }

    var variant: Variant = .primary { didSet { updateAppearance() } }
    var sketchSize: Size = .md { didSet { updateAppearance() } }

    private let borderLayer = CAShapeLayer()
    private var currentBorderPath: CGPath?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        updateAppearance()
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }

    private func updateAppearance() {
        let fontSize: CGFloat
        let insets: UIEdgeInsets

        switch sketchSize {
        case .sm:
            fontSize = 14
            insets = UIEdgeInsets(top: 4, left: 12, bottom: 4, right: 12)
        case .md:
            fontSize = 16
            insets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        case .lg:
            fontSize = 20
            insets = UIEdgeInsets(top: 12, left: 32, bottom: 12, right: 32)
        }

        titleLabel?.font = UIFont(name: "Marker Felt", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)
        contentEdgeInsets = insets

        switch variant {
        case .primary:
            backgroundColor = UIColor(red: 254/255, green: 240/255, blue: 138/255, alpha: 1)
        case .secondary:
            backgroundColor = Theme.paper
        case .danger:
            backgroundColor = UIColor(red: 254/255, green: 202/255, blue: 202/255, alpha: 1)
        }

        setTitleColor(Theme.ink, for: .normal)
        tintColor = Theme.ink

        layer.shadowColor = Theme.ink.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
        layer.shadowOpacity = 1
        layer.shadowRadius = 0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if currentBorderPath == nil || !bounds.equalTo(CGRect.zero) {
            drawRoughBorder()
        }
    }

    private func drawRoughBorder() {
        let path = UIBezierPath()
        let w = bounds.width
        let h = bounds.height
        let j: CGFloat = 1.2

        func jt(_ v: CGFloat) -> CGFloat { v + CGFloat.random(in: -j...j) }

        path.move(to: CGPoint(x: jt(0), y: jt(0)))
        path.addLine(to: CGPoint(x: jt(w/2), y: jt(0)))
        path.addLine(to: CGPoint(x: jt(w), y: jt(0)))
        path.addLine(to: CGPoint(x: jt(w), y: jt(h/2)))
        path.addLine(to: CGPoint(x: jt(w), y: jt(h)))
        path.addLine(to: CGPoint(x: jt(w/2), y: jt(h)))
        path.addLine(to: CGPoint(x: jt(0), y: jt(h)))
        path.addLine(to: CGPoint(x: jt(0), y: jt(h/2)))
        path.close()

        currentBorderPath = path.cgPath
        borderLayer.path = path.cgPath
        borderLayer.strokeColor = Theme.ink.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 2.5
        borderLayer.lineCap = .round
        borderLayer.lineJoin = .round
        borderLayer.frame = bounds

        if borderLayer.superlayer == nil {
            layer.addSublayer(borderLayer)
        }
    }

    @objc private func touchDown() {
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.98, y: 0.98).translatedBy(x: 0, y: 2)
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }

    @objc private func touchUp() {
        UIView.animate(withDuration: 0.1) {
            self.transform = .identity
            self.layer.shadowOffset = CGSize(width: 3, height: 3)
        }
    }
}
