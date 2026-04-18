import UIKit

struct Photo: Identifiable {
    let id: String
    var url: String?
    var image: UIImage?
}

extension UIImage {
    static func placeholder(color: UIColor, size: CGSize = CGSize(width: 100, height: 100)) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: size))
        }
    }
}
