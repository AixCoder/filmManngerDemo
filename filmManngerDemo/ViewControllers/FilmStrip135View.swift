import UIKit

class FilmStrip135View: UIView {
    var photos: [Photo] = [] {
        didSet { reloadPhotos() }
    }
    var startIndex: Int = 0 {
        didSet { updateEdgeLabels() }
    }
    var filmType: String = "" {
        didSet { updateEdgeLabels() }
    }

    private let photoHeight: CGFloat = 150
    private let edgeHeight: CGFloat = 40
    private let horizontalPadding: CGFloat = 16

    private let photosStackView = UIStackView()
    private let topTextStack = UIStackView()
    private let bottomTextStack = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = UIColor(red: 5/255, green: 5/255, blue: 5/255, alpha: 1)
        layer.borderColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1).cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 4

        // Top text stack
        topTextStack.axis = .horizontal
        topTextStack.distribution = .equalSpacing
        topTextStack.alignment = .center
        topTextStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topTextStack)

        // Photos stack
        photosStackView.axis = .horizontal
        photosStackView.spacing = 4
        photosStackView.alignment = .center
        photosStackView.distribution = .fill
        photosStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(photosStackView)

        // Bottom text stack
        bottomTextStack.axis = .horizontal
        bottomTextStack.distribution = .equalSpacing
        bottomTextStack.alignment = .center
        bottomTextStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bottomTextStack)

        NSLayoutConstraint.activate([
            topTextStack.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            topTextStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            topTextStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            topTextStack.heightAnchor.constraint(equalToConstant: 16),

            photosStackView.topAnchor.constraint(equalTo: topTextStack.bottomAnchor, constant: 8),
            photosStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            photosStackView.heightAnchor.constraint(equalToConstant: photoHeight),

            bottomTextStack.topAnchor.constraint(equalTo: photosStackView.bottomAnchor, constant: 8),
            bottomTextStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            bottomTextStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            bottomTextStack.heightAnchor.constraint(equalToConstant: 16)
        ])

        updateEdgeLabels()
    }

    private func reloadPhotos() {
        photosStackView.arrangedSubviews.forEach {
            photosStackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        for photo in photos {
            let container = UIView()
            container.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)

            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true

            if let image = photo.image {
                imageView.image = applyContactSheetFilter(to: image)
            } else {
                imageView.backgroundColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
            }

            imageView.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.topAnchor.constraint(equalTo: container.topAnchor, constant: 2),
                imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 2),
                imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -2),
                imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -2)
            ])

            container.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                container.heightAnchor.constraint(equalToConstant: photoHeight),
                container.widthAnchor.constraint(equalTo: container.heightAnchor, multiplier: 3.0 / 2.0)
            ])

            photosStackView.addArrangedSubview(container)
        }

        let emptyCount = max(0, 6 - photos.count)
        for _ in 0..<emptyCount {
            let emptyView = UIView()
            emptyView.backgroundColor = .clear
            emptyView.layer.borderColor = UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1).cgColor
            emptyView.layer.borderWidth = 1
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                emptyView.heightAnchor.constraint(equalToConstant: photoHeight),
                emptyView.widthAnchor.constraint(equalTo: emptyView.heightAnchor, multiplier: 3.0 / 2.0)
            ])
            photosStackView.addArrangedSubview(emptyView)
        }

        setNeedsDisplay()
    }

    private func updateEdgeLabels() {
        topTextStack.arrangedSubviews.forEach {
            topTextStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
        bottomTextStack.arrangedSubviews.forEach {
            bottomTextStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let isFuji = filmType.lowercased().contains("fuji")
        let edgeText = isFuji ? "FUJI 200" : "KODAK 400"
        let edgeColor: UIColor = isFuji
            ? UIColor(red: 16/255, green: 185/255, blue: 129/255, alpha: 0.8)
            : UIColor(red: 250/255, green: 204/255, blue: 21/255, alpha: 0.8)

        // Top: 3 labels
        for _ in 0..<3 {
            let label = UILabel()
            label.text = edgeText
            label.font = UIFont(name: "Courier", size: 10) ?? UIFont.monospacedSystemFont(ofSize: 10, weight: .bold)
            label.textColor = edgeColor
            topTextStack.addArrangedSubview(label)
        }

        // Bottom: 3 segments with pattern + number
        func makeSegment(pattern: String, number: String) -> UILabel {
            let label = UILabel()
            let attr = NSMutableAttributedString()
            let pAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Courier", size: 10) ?? UIFont.monospacedSystemFont(ofSize: 10, weight: .bold),
                .foregroundColor: edgeColor.withAlphaComponent(0.7)
            ]
            let nAttr: [NSAttributedString.Key: Any] = [
                .font: UIFont(name: "Courier", size: 10) ?? UIFont.monospacedSystemFont(ofSize: 10, weight: .bold),
                .foregroundColor: edgeColor
            ]
            attr.append(NSAttributedString(string: pattern, attributes: pAttr))
            attr.append(NSAttributedString(string: number, attributes: nAttr))
            label.attributedText = attr
            return label
        }

        let s1 = startIndex + 1
        let s3 = startIndex + 3
        let s5 = startIndex + 5

        bottomTextStack.addArrangedSubview(makeSegment(pattern: "||||·||·· ", number: "\(s1)A"))
        bottomTextStack.addArrangedSubview(makeSegment(pattern: "||·||||·· ", number: "\(s3)A"))
        bottomTextStack.addArrangedSubview(makeSegment(pattern: "||||·||·· ", number: "\(s5)A"))
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        let sprocketCount = max(24, photos.count * 8 + 4)
        let sprocketWidth: CGFloat = 8
        let sprocketHeight: CGFloat = 12
        let edgePadding: CGFloat = 8

        let availableWidth = rect.width - edgePadding * 2
        let spacing = availableWidth / CGFloat(sprocketCount - 1)

        let sprocketColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)

        // Top sprockets
        for i in 0..<sprocketCount {
            let x = edgePadding + CGFloat(i) * spacing - sprocketWidth / 2
            let y: CGFloat = 4
            let path = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: sprocketWidth, height: sprocketHeight), cornerRadius: 2)
            sprocketColor.setFill()
            path.fill()
        }

        // Bottom sprockets
        for i in 0..<sprocketCount {
            let x = edgePadding + CGFloat(i) * spacing - sprocketWidth / 2
            let y = rect.height - sprocketHeight - 4
            let path = UIBezierPath(roundedRect: CGRect(x: x, y: y, width: sprocketWidth, height: sprocketHeight), cornerRadius: 2)
            sprocketColor.setFill()
            path.fill()
        }
    }

    private func applyContactSheetFilter(to image: UIImage) -> UIImage {
        guard let ciImage = CIImage(image: image) else { return image }

        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(1.25, forKey: kCIInputContrastKey)
        filter?.setValue(0.5, forKey: kCIInputSaturationKey)

        guard let outputImage = filter?.outputImage else { return image }
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return image }

        return UIImage(cgImage: cgImage)
    }
}
