import UIKit

class PhotoCell: UICollectionViewCell {
    static let reuseId = "PhotoCell"

    private let containerView = UIView()
    private let imageView = UIImageView()
    private let badgeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])

        containerView.backgroundColor = .white
        containerView.layer.borderColor = Theme.ink.cgColor
        containerView.layer.borderWidth = 2
        containerView.layer.shadowColor = Theme.ink.cgColor
        containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowRadius = 0

        containerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true

        containerView.addSubview(badgeLabel)
        badgeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            badgeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            badgeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12)
        ])
        badgeLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        badgeLabel.textColor = .white
        badgeLabel.font = UIFont(name: "Courier", size: 10) ?? UIFont.monospacedSystemFont(ofSize: 10, weight: .regular)
        badgeLabel.textAlignment = .center
        badgeLabel.layer.cornerRadius = 2
        badgeLabel.clipsToBounds = true
    }

    func configure(with photo: Photo, index: Int) {
        if let image = photo.image {
            imageView.image = image
        } else {
            imageView.backgroundColor = UIColor(white: 0.94, alpha: 1)
        }
        badgeLabel.text = "  FF\(index + 1)  "
    }

    func animateEntrance(delay: TimeInterval) {
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.3, delay: delay, options: [.curveEaseOut], animations: {
            self.containerView.alpha = 1
            self.containerView.transform = .identity
        })
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.1) {
                if self.isHighlighted {
                    self.containerView.transform = CGAffineTransform(scaleX: 1.02, y: 1.02).rotated(by: .pi / 180)
                    self.containerView.layer.shadowOffset = CGSize(width: 4, height: 4)
                    self.containerView.layer.zPosition = 10
                } else {
                    self.containerView.transform = .identity
                    self.containerView.layer.shadowOffset = CGSize(width: 2, height: 2)
                    self.containerView.layer.zPosition = 0
                }
            }
        }
    }
}
