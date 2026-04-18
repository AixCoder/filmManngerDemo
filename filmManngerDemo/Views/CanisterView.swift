import UIKit

class CanisterView: UIView {
    var label: String = "FILM" { didSet { setNeedsDisplay() } }
    var filmType: String = "kodak" { didSet { setNeedsDisplay() } }
    var onTap: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }

    @objc private func handleTap() {
        onTap?()
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                self.transform = .identity
            }, completion: nil)
        }
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let scale = min(rect.width / 120.0, rect.height / 160.0)
        let offsetX = (rect.width - 120 * scale) / 2
        let offsetY = (rect.height - 160 * scale) / 2

        context.saveGState()
        context.translateBy(x: offsetX, y: offsetY)
        context.scaleBy(x: scale, y: scale)

        let isFuji = filmType.lowercased().contains("fuji") || filmType.lowercased().contains("superia")
        let isBW = filmType.lowercased().contains("b/w") || filmType.lowercased().contains("hp5") || filmType.lowercased().contains("tmax")
        let mainColor = isFuji ? Theme.fujiGreen : (isBW ? Theme.bwGray : Theme.kodakYellow)
        let textColor: UIColor = isBW ? Theme.ink : (isFuji ? .white : UIColor(red: 217/255, green: 38/255, blue: 38/255, alpha: 1))
        let ink = Theme.ink

        // Drop shadow
        context.setShadow(offset: CGSize(width: 3, height: 3), blur: 0, color: UIColor.black.withAlphaComponent(0.2).cgColor)

        // Main Body
        let body = UIBezierPath()
        body.move(to: CGPoint(x: 30, y: 30))
        body.addCurve(to: CGPoint(x: 30, y: 110), controlPoint1: CGPoint(x: 27, y: 30), controlPoint2: CGPoint(x: 27, y: 110))
        body.addLine(to: CGPoint(x: 90, y: 110))
        body.addCurve(to: CGPoint(x: 90, y: 30), controlPoint1: CGPoint(x: 93, y: 110), controlPoint2: CGPoint(x: 93, y: 30))
        body.close()
        UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).setFill()
        ink.setStroke()
        context.setLineWidth(3)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        context.addPath(body.cgPath)
        context.drawPath(using: .fillStroke)

        context.setShadow(offset: .zero, blur: 0, color: nil)

        // Top Spool Cap
        let topCap = UIBezierPath()
        topCap.move(to: CGPoint(x: 25, y: 20))
        topCap.addCurve(to: CGPoint(x: 95, y: 20), controlPoint1: CGPoint(x: 25, y: 15), controlPoint2: CGPoint(x: 95, y: 15))
        topCap.addLine(to: CGPoint(x: 95, y: 30))
        topCap.addLine(to: CGPoint(x: 25, y: 30))
        topCap.close()
        UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1).setFill()
        context.addPath(topCap.cgPath)
        context.fillPath()

        let topDetail = UIBezierPath()
        topDetail.move(to: CGPoint(x: 45, y: 10))
        topDetail.addLine(to: CGPoint(x: 75, y: 10))
        topDetail.addLine(to: CGPoint(x: 75, y: 20))
        topDetail.addLine(to: CGPoint(x: 45, y: 20))
        topDetail.close()
        UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1).setFill()
        context.addPath(topDetail.cgPath)
        context.fillPath()

        let topKnob = UIBezierPath(rect: CGRect(x: 55, y: 2, width: 10, height: 8))
        UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1).setFill()
        context.addPath(topKnob.cgPath)
        context.fillPath()

        // Bottom Spool Cap
        let botCap = UIBezierPath()
        botCap.move(to: CGPoint(x: 25, y: 110))
        botCap.addCurve(to: CGPoint(x: 95, y: 110), controlPoint1: CGPoint(x: 25, y: 115), controlPoint2: CGPoint(x: 95, y: 115))
        botCap.addLine(to: CGPoint(x: 95, y: 100))
        botCap.addLine(to: CGPoint(x: 25, y: 100))
        botCap.close()
        UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1).setFill()
        context.addPath(botCap.cgPath)
        context.fillPath()

        let botDetail = UIBezierPath()
        botDetail.move(to: CGPoint(x: 45, y: 120))
        botDetail.addLine(to: CGPoint(x: 75, y: 120))
        botDetail.addLine(to: CGPoint(x: 75, y: 110))
        botDetail.addLine(to: CGPoint(x: 45, y: 110))
        botDetail.close()
        UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1).setFill()
        context.addPath(botDetail.cgPath)
        context.fillPath()

        // Film Flap
        let flap = UIBezierPath()
        flap.move(to: CGPoint(x: 90, y: 50))
        flap.addLine(to: CGPoint(x: 115, y: 50))
        flap.addLine(to: CGPoint(x: 115, y: 90))
        flap.addLine(to: CGPoint(x: 90, y: 90))
        flap.close()
        UIColor(red: 68/255, green: 68/255, blue: 68/255, alpha: 1).setFill()
        context.addPath(flap.cgPath)
        context.fillPath()

        // Flap dashed border
        context.setLineDash(phase: 0, lengths: [3, 3])
        UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1).setStroke()
        context.setLineWidth(1.5)
        context.addPath(flap.cgPath)
        context.strokePath()
        context.setLineDash(phase: 0, lengths: [])

        // Flap solid border
        ink.setStroke()
        context.setLineWidth(3)
        context.setLineJoin(.round)
        context.addPath(flap.cgPath)
        context.strokePath()

        // Wrap Label
        let labelRect = UIBezierPath(rect: CGRect(x: 30, y: 40, width: 60, height: 50))
        mainColor.setFill()
        ink.setStroke()
        context.setLineWidth(3)
        context.setLineJoin(.round)
        context.addPath(labelRect.cgPath)
        context.drawPath(using: .fillStroke)

        // Label text
        let displayLabel = label.count > 10 ? String(label.prefix(10)) + "..." : label
        let words = displayLabel.split(separator: " ")
        let firstWord = words.first.map(String.init) ?? "FILM"
        let rest = words.dropFirst().joined(separator: " ")

        let markerFont = UIFont(name: "Marker Felt", size: 18) ?? UIFont.boldSystemFont(ofSize: 18)
        let attrs1: [NSAttributedString.Key: Any] = [.font: markerFont, .foregroundColor: textColor]

        context.saveGState()
        context.translateBy(x: 60, y: 65)
        context.rotate(by: -4 * .pi / 180)
        let str1 = firstWord as NSString
        let size1 = str1.size(withAttributes: attrs1)
        str1.draw(at: CGPoint(x: -size1.width/2, y: -size1.height/2), withAttributes: attrs1)
        context.restoreGState()

        let markerFont2 = UIFont(name: "Marker Felt", size: 14) ?? UIFont.boldSystemFont(ofSize: 14)
        let attrs2: [NSAttributedString.Key: Any] = [.font: markerFont2, .foregroundColor: ink]
        context.saveGState()
        context.translateBy(x: 60, y: 80)
        context.rotate(by: -4 * .pi / 180)
        let str2 = (rest.isEmpty ? "400" : rest) as NSString
        let size2 = str2.size(withAttributes: attrs2)
        str2.draw(at: CGPoint(x: -size2.width/2, y: -size2.height/2), withAttributes: attrs2)
        context.restoreGState()

        // Detail lines
        let d1 = UIBezierPath()
        d1.move(to: CGPoint(x: 35, y: 45)); d1.addLine(to: CGPoint(x: 40, y: 45))
        d1.move(to: CGPoint(x: 35, y: 50)); d1.addLine(to: CGPoint(x: 38, y: 50))
        ink.setStroke()
        context.setLineWidth(1.5)
        context.setLineCap(.round)
        context.addPath(d1.cgPath)
        context.strokePath()

        let d2 = UIBezierPath()
        d2.move(to: CGPoint(x: 85, y: 85)); d2.addLine(to: CGPoint(x: 85, y: 80))
        context.addPath(d2.cgPath)
        context.strokePath()

        context.restoreGState()
    }
}
