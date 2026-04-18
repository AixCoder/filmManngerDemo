import UIKit

class RollDetailHeaderView: UICollectionReusableView {
    static let reuseId = "RollDetailHeaderView"

    var onBack: (() -> Void)?
    var onEdit: (() -> Void)?
    var onContactSheet: (() -> Void)?

    private let backButton = UIButton(type: .system)
    private let titleCard = UIView()
    private let titleLabel = UILabel()
    private let infoStack = UIStackView()
    private let editButton = SketchButton()
    private let contactSheetButton = SketchButton()
    private let separator = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        // Back button
        backButton.setTitle(" 回到桌面", for: .normal)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = Theme.ink.withAlphaComponent(0.7)
        backButton.titleLabel?.font = UIFont(name: "Marker Felt", size: 16) ?? UIFont.systemFont(ofSize: 16)
        backButton.setTitleColor(Theme.ink.withAlphaComponent(0.7), for: .normal)
        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backButton)

        // Title card
        titleCard.backgroundColor = .white
        titleCard.layer.borderColor = Theme.ink.cgColor
        titleCard.layer.borderWidth = 2
        titleCard.layer.shadowColor = Theme.ink.cgColor
        titleCard.layer.shadowOffset = CGSize(width: 2, height: 2)
        titleCard.layer.shadowOpacity = 1
        titleCard.layer.shadowRadius = 0
        titleCard.translatesAutoresizingMaskIntoConstraints = false
        titleCard.transform = CGAffineTransform(rotationAngle: .pi / 180)
        addSubview(titleCard)

        titleLabel.font = UIFont(name: "Marker Felt", size: 32) ?? UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = Theme.ink
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleCard.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: titleCard.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: titleCard.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: titleCard.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: titleCard.bottomAnchor, constant: -8)
        ])

        // Info stack
        infoStack.axis = .vertical
        infoStack.spacing = 2
        infoStack.alignment = .leading
        infoStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(infoStack)

        // Buttons
        editButton.setTitle(" 编辑胶卷", for: .normal)
        editButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        editButton.variant = .primary
        editButton.sketchSize = .md
        editButton.transform = CGAffineTransform(rotationAngle: .pi / 180)
        editButton.addTarget(self, action: #selector(didTapEdit), for: .touchUpInside)

        contactSheetButton.setTitle(" 接触印象", for: .normal)
        contactSheetButton.setImage(UIImage(systemName: "square.grid.2x2"), for: .normal)
        contactSheetButton.variant = .primary
        contactSheetButton.sketchSize = .md
        contactSheetButton.backgroundColor = UIColor(red: 219/255, green: 234/255, blue: 254/255, alpha: 1)
        contactSheetButton.transform = CGAffineTransform(rotationAngle: -.pi / 180)
        contactSheetButton.addTarget(self, action: #selector(didTapContactSheet), for: .touchUpInside)

        let buttonsStack = UIStackView()
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 12
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.addArrangedSubview(editButton)
        buttonsStack.addArrangedSubview(contactSheetButton)
        addSubview(buttonsStack)

        // Separator
        separator.backgroundColor = Theme.ink
        separator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(separator)

        // Layout
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),

            titleCard.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 12),
            titleCard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),

            infoStack.leadingAnchor.constraint(equalTo: titleCard.trailingAnchor, constant: 16),
            infoStack.centerYAnchor.constraint(equalTo: titleCard.centerYAnchor),
            infoStack.trailingAnchor.constraint(lessThanOrEqualTo: buttonsStack.leadingAnchor, constant: -12),

            buttonsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            buttonsStack.bottomAnchor.constraint(equalTo: titleCard.bottomAnchor),
            buttonsStack.topAnchor.constraint(greaterThanOrEqualTo: backButton.bottomAnchor, constant: 12),

            separator.heightAnchor.constraint(equalToConstant: 2),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            separator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            separator.topAnchor.constraint(equalTo: titleCard.bottomAnchor, constant: 12),
            separator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

    func configure(with roll: Roll) {
        titleLabel.text = roll.name

        infoStack.arrangedSubviews.forEach {
            infoStack.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        let countLabel = UILabel()
        countLabel.text = "\(roll.photos.count) 张"
        countLabel.font = UIFont(name: "Marker Felt", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        countLabel.textColor = Theme.ink.withAlphaComponent(0.6)
        infoStack.addArrangedSubview(countLabel)

        if let camera = roll.camera, !camera.isEmpty {
            let cameraLabel = UILabel()
            cameraLabel.text = "(\(camera))"
            cameraLabel.font = UIFont(name: "Chalkduster", size: 14) ?? UIFont.systemFont(ofSize: 14)
            cameraLabel.textColor = Theme.ink.withAlphaComponent(0.5)
            infoStack.addArrangedSubview(cameraLabel)
        }
    }

    @objc private func didTapBack() { onBack?() }
    @objc private func didTapEdit() { onEdit?() }
    @objc private func didTapContactSheet() { onContactSheet?() }
}
