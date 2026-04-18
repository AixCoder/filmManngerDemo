import UIKit

class AppLogoView: UIView {
    var inkColor: UIColor = Theme.ink

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let scale = min(rect.width, rect.height) / 200.0
        let offsetX = (rect.width - 200 * scale) / 2
        let offsetY = (rect.height - 200 * scale) / 2

        context.saveGState()
        context.translateBy(x: offsetX, y: offsetY)
        context.scaleBy(x: scale, y: scale)

        let paper = Theme.paper

        // 1. Shadow
        let shadow = UIBezierPath(ovalIn: CGRect(x: 45, y: 172, width: 110, height: 16))
        inkColor.withAlphaComponent(0.1).setFill()
        shadow.fill()

        // 2. Film strip swirl
        let film = UIBezierPath()
        film.move(to: CGPoint(x: 30, y: 140))
        film.addQuadCurve(to: CGPoint(x: 30, y: 40), controlPoint: CGPoint(x: -10, y: 90))
        inkColor.withAlphaComponent(0.15).setStroke()
        context.setLineWidth(20)
        context.setLineCap(.round)
        context.addPath(film.cgPath)
        context.strokePath()

        // 3. Flash bulb
        let flashStem = UIBezierPath()
        flashStem.move(to: CGPoint(x: 135, y: 60))
        flashStem.addCurve(to: CGPoint(x: 160, y: 55), controlPoint1: CGPoint(x: 145, y: 50), controlPoint2: CGPoint(x: 155, y: 50))
        inkColor.setStroke()
        context.setLineWidth(4)
        context.setLineCap(.round)
        context.addPath(flashStem.cgPath)
        context.strokePath()

        let flashBulb = UIBezierPath(ovalIn: CGRect(x: 147, y: 22, width: 36, height: 36))
        paper.setFill()
        inkColor.setStroke()
        context.setLineWidth(4)
        flashBulb.fill()
        context.addPath(flashBulb.cgPath)
        context.strokePath()

        let reflector = UIBezierPath()
        reflector.move(to: CGPoint(x: 165, y: 22)); reflector.addLine(to: CGPoint(x: 165, y: 58))
        reflector.move(to: CGPoint(x: 147, y: 40)); reflector.addLine(to: CGPoint(x: 183, y: 40))
        reflector.move(to: CGPoint(x: 152, y: 28)); reflector.addLine(to: CGPoint(x: 178, y: 52))
        reflector.move(to: CGPoint(x: 152, y: 52)); reflector.addLine(to: CGPoint(x: 178, y: 28))
        inkColor.withAlphaComponent(0.5).setStroke()
        context.setLineWidth(2)
        context.addPath(reflector.cgPath)
        context.strokePath()

        let bulbCenter = UIBezierPath(ovalIn: CGRect(x: 161, y: 36, width: 8, height: 8))
        inkColor.setFill()
        bulbCenter.fill()

        // 4. Main body background
        let body = UIBezierPath()
        body.move(to: CGPoint(x: 55, y: 50))
        body.addLine(to: CGPoint(x: 145, y: 50))
        body.addLine(to: CGPoint(x: 145, y: 170))
        body.addLine(to: CGPoint(x: 55, y: 170))
        body.close()
        paper.setFill()
        body.fill()

        // 5. Hood
        let hood = UIBezierPath()
        hood.move(to: CGPoint(x: 55, y: 50))
        hood.addLine(to: CGPoint(x: 65, y: 20))
        hood.addLine(to: CGPoint(x: 135, y: 22))
        hood.addLine(to: CGPoint(x: 145, y: 50))
        hood.close()
        paper.setFill()
        hood.fill()
        inkColor.setStroke()
        context.setLineWidth(6)
        context.setLineJoin(.round)
        context.addPath(hood.cgPath)
        context.strokePath()

        let hoodLines = UIBezierPath()
        hoodLines.move(to: CGPoint(x: 65, y: 20)); hoodLines.addLine(to: CGPoint(x: 65, y: 48))
        hoodLines.move(to: CGPoint(x: 135, y: 22)); hoodLines.addLine(to: CGPoint(x: 135, y: 48))
        hoodLines.move(to: CGPoint(x: 65, y: 20)); hoodLines.addLine(to: CGPoint(x: 100, y: 5)); hoodLines.addLine(to: CGPoint(x: 135, y: 22))
        context.setLineWidth(4)
        context.setLineJoin(.round)
        inkColor.setStroke()
        context.addPath(hoodLines.cgPath)
        context.strokePath()

        // 6. Body outline + sketch lines
        let bodyRect = UIBezierPath(roundedRect: CGRect(x: 55, y: 50, width: 90, height: 120), cornerRadius: 4)
        inkColor.setStroke()
        context.setLineWidth(6)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.addPath(bodyRect.cgPath)
        context.strokePath()

        let sketch = UIBezierPath()
        sketch.move(to: CGPoint(x: 52, y: 55)); sketch.addLine(to: CGPoint(x: 148, y: 52))
        sketch.move(to: CGPoint(x: 58, y: 168)); sketch.addLine(to: CGPoint(x: 142, y: 172))
        sketch.move(to: CGPoint(x: 55, y: 45)); sketch.addLine(to: CGPoint(x: 53, y: 175))
        sketch.move(to: CGPoint(x: 146, y: 45)); sketch.addLine(to: CGPoint(x: 144, y: 175))
        context.setLineWidth(3)
        context.setLineCap(.round)
        context.addPath(sketch.cgPath)
        context.strokePath()

        // 7. Nameplate
        let nameplate = UIBezierPath(roundedRect: CGRect(x: 75, y: 60, width: 50, height: 12), cornerRadius: 2)
        paper.setFill()
        nameplate.fill()
        inkColor.setStroke()
        context.setLineWidth(3)
        context.addPath(nameplate.cgPath)
        context.strokePath()

        let nameText = UIBezierPath()
        nameText.move(to: CGPoint(x: 80, y: 66))
        nameText.addQuadCurve(to: CGPoint(x: 120, y: 66), controlPoint: CGPoint(x: 100, y: 62))
        context.setLineWidth(2)
        context.setLineCap(.round)
        inkColor.setStroke()
        context.addPath(nameText.cgPath)
        context.strokePath()

        // 8. Viewing Lens (Top)
        let topLens = UIBezierPath(ovalIn: CGRect(x: 80, y: 76, width: 40, height: 38))
        paper.setFill()
        context.setLineWidth(5)
        inkColor.setStroke()
        context.addPath(topLens.cgPath)
        context.strokePath()
        topLens.fill()

        let topInner = UIBezierPath(ovalIn: CGRect(x: 80, y: 76, width: 38, height: 40))
        context.setLineWidth(3)
        inkColor.setStroke()
        context.addPath(topInner.cgPath)
        context.strokePath()

        let topCenter = UIBezierPath(ovalIn: CGRect(x: 92, y: 87, width: 16, height: 16))
        inkColor.setFill()
        topCenter.fill()

        let topArc = UIBezierPath()
        topArc.addArc(withCenter: CGPoint(x: 100, y: 95), radius: 12, startAngle: .pi, endAngle: 0, clockwise: true)
        paper.setStroke()
        context.setLineWidth(3)
        context.setLineCap(.round)
        context.addPath(topArc.cgPath)
        context.strokePath()

        // 9. Taking Lens (Bottom)
        let botLens = UIBezierPath(ovalIn: CGRect(x: 75, y: 116, width: 50, height: 48))
        paper.setFill()
        context.setLineWidth(6)
        inkColor.setStroke()
        context.addPath(botLens.cgPath)
        context.strokePath()
        botLens.fill()

        let botInner = UIBezierPath(ovalIn: CGRect(x: 78, y: 113, width: 48, height: 50))
        context.setLineWidth(3)
        inkColor.setStroke()
        context.addPath(botInner.cgPath)
        context.strokePath()

        let botCenter = UIBezierPath(ovalIn: CGRect(x: 88, y: 128, width: 24, height: 24))
        inkColor.setFill()
        botCenter.fill()

        let botArc = UIBezierPath()
        botArc.addArc(withCenter: CGPoint(x: 100, y: 140), radius: 15, startAngle: .pi, endAngle: 0, clockwise: true)
        paper.setStroke()
        context.setLineWidth(4)
        context.setLineCap(.round)
        context.addPath(botArc.cgPath)
        context.strokePath()

        // 10. Left Focus Knob
        let knob = UIBezierPath(roundedRect: CGRect(x: 42, y: 120, width: 13, height: 35), cornerRadius: 3)
        paper.setFill()
        context.setLineWidth(4)
        inkColor.setStroke()
        knob.fill()
        context.addPath(knob.cgPath)
        context.strokePath()

        let kLines = UIBezierPath()
        kLines.move(to: CGPoint(x: 45, y: 125)); kLines.addLine(to: CGPoint(x: 45, y: 150))
        kLines.move(to: CGPoint(x: 50, y: 125)); kLines.addLine(to: CGPoint(x: 50, y: 150))
        context.setLineWidth(2)
        inkColor.setStroke()
        context.addPath(kLines.cgPath)
        context.strokePath()

        // 11. Right Winding Crank
        let crankBase = UIBezierPath(ovalIn: CGRect(x: 142, y: 85, width: 20, height: 20))
        paper.setFill()
        context.setLineWidth(4)
        inkColor.setStroke()
        crankBase.fill()
        context.addPath(crankBase.cgPath)
        context.strokePath()

        let crankArm = UIBezierPath()
        crankArm.move(to: CGPoint(x: 152, y: 95))
        crankArm.addLine(to: CGPoint(x: 165, y: 105))
        context.setLineWidth(4)
        context.setLineCap(.round)
        inkColor.setStroke()
        context.addPath(crankArm.cgPath)
        context.strokePath()

        let crankHandle = UIBezierPath(ovalIn: CGRect(x: 161, y: 101, width: 8, height: 8))
        inkColor.setFill()
        crankHandle.fill()

        // 12. Star/Sparkle accents
        func star(at p: CGPoint, s: CGFloat) {
            let st = UIBezierPath()
            st.move(to: CGPoint(x: p.x - s, y: p.y))
            st.addQuadCurve(to: CGPoint(x: p.x + s, y: p.y), controlPoint: CGPoint(x: p.x, y: p.y - s))
            st.addQuadCurve(to: CGPoint(x: p.x - s, y: p.y), controlPoint: CGPoint(x: p.x, y: p.y + s))
            inkColor.setFill()
            st.fill()
        }
        star(at: CGPoint(x: 25, y: 30), s: 5)
        star(at: CGPoint(x: 185, y: 140), s: 3.5)

        context.restoreGState()
    }
}
