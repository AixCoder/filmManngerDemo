import UIKit
import PhotosUI

class HomeViewController: UIViewController {
    private var rolls: [Roll] = [
        Roll(id: "1", name: "Kodak Gold 200", type: "kodak", camera: "Olympus OM-1", photos: (1...8).map {
            Photo(id: "p1-\($0)", image: UIImage.placeholder(color: UIColor(hue: CGFloat($0) / 10, saturation: 0.3, brightness: 0.9, alpha: 1)))
        }),
        Roll(id: "2", name: "Fuji Superia 400", type: "fuji", camera: "Canon AE-1", photos: (1...5).map {
            Photo(id: "p2-\($0)", image: UIImage.placeholder(color: UIColor(hue: 0.3 + CGFloat($0) / 15, saturation: 0.4, brightness: 0.85, alpha: 1)))
        }),
        Roll(id: "3", name: "Ilford HP5", type: "b/w", camera: "Leica M6", photos: (1...12).map {
            Photo(id: "p3-\($0)", image: UIImage.placeholder(color: UIColor(white: 0.3 + CGFloat($0) / 30, alpha: 1)))
        })
    ]

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let headerStack = UIStackView()
    private let emptyStateStack = UIStackView()
    private let gridStack = UIStackView()
    private let uploadButton = SketchButton()

    var onSelectRoll: ((String) -> Void)?
    var onOpenAbout: (() -> Void)?
    var onCreateNew: (([UIImage]) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.paper
        setupUI()
        reloadData()
    }

    private func setupUI() {
        // Scroll view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        // Header
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.distribution = .equalSpacing
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        let leftStack = UIStackView()
        leftStack.axis = .horizontal
        leftStack.spacing = 8
        leftStack.alignment = .center

        let logoView = AppLogoView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        logoView.heightAnchor.constraint(equalToConstant: 32).isActive = true

        let titleStack = UIStackView()
        titleStack.axis = .vertical
        titleStack.alignment = .leading
        titleStack.spacing = 2

        let titleLabel = UILabel()
        titleLabel.text = "昨日重现"
        titleLabel.font = UIFont(name: "Marker Felt", size: 32) ?? UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = Theme.ink

        let subtitleLabel = UILabel()
        subtitleLabel.text = "Yesterday Once More"
        subtitleLabel.font = UIFont(name: "Chalkduster", size: 14) ?? UIFont.italicSystemFont(ofSize: 14)
        subtitleLabel.textColor = Theme.ink.withAlphaComponent(0.6)

        titleStack.addArrangedSubview(titleLabel)
        titleStack.addArrangedSubview(subtitleLabel)

        let aboutButton = UIButton(type: .system)
        aboutButton.setImage(UIImage(systemName: "info.circle"), for: .normal)
        aboutButton.tintColor = Theme.ink.withAlphaComponent(0.3)
        aboutButton.addTarget(self, action: #selector(didTapAbout), for: .touchUpInside)

        leftStack.addArrangedSubview(logoView)
        leftStack.addArrangedSubview(titleStack)
        leftStack.addArrangedSubview(aboutButton)

        uploadButton.setTitle(" 冲洗新胶卷", for: .normal)
        uploadButton.setImage(UIImage(systemName: "plus"), for: .normal)
        uploadButton.tintColor = Theme.ink
        uploadButton.variant = .primary
        uploadButton.sketchSize = .md
        uploadButton.addTarget(self, action: #selector(didTapUpload), for: .touchUpInside)

        headerStack.addArrangedSubview(leftStack)
        headerStack.addArrangedSubview(uploadButton)

        contentView.addSubview(headerStack)
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            headerStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            headerStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])

        // Separator
        let separator = UIView()
        separator.backgroundColor = Theme.ink
        separator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separator)
        separator.heightAnchor.constraint(equalToConstant: 2).isActive = true
        separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
        separator.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 12).isActive = true

        // Empty state
        emptyStateStack.axis = .vertical
        emptyStateStack.alignment = .center
        emptyStateStack.spacing = 16
        emptyStateStack.translatesAutoresizingMaskIntoConstraints = false

        let emptyIcon = EmptyStateIconView()
        emptyIcon.translatesAutoresizingMaskIntoConstraints = false
        emptyIcon.widthAnchor.constraint(equalToConstant: 120).isActive = true
        emptyIcon.heightAnchor.constraint(equalToConstant: 120).isActive = true

        let emptyLabel = UILabel()
        emptyLabel.text = "桌面空空如也，冲洗一卷，重现昨日的记忆吧！"
        emptyLabel.font = UIFont(name: "Marker Felt", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        emptyLabel.textColor = Theme.ink.withAlphaComponent(0.7)
        emptyLabel.textAlignment = .center
        emptyLabel.numberOfLines = 0

        let arrowView = ArrowIconView()
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        arrowView.heightAnchor.constraint(equalToConstant: 60).isActive = true

        emptyStateStack.addArrangedSubview(emptyIcon)
        emptyStateStack.addArrangedSubview(emptyLabel)
        emptyStateStack.addArrangedSubview(arrowView)

        contentView.addSubview(emptyStateStack)
        NSLayoutConstraint.activate([
            emptyStateStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emptyStateStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 40),
            emptyStateStack.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 32),
            emptyStateStack.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -32)
        ])

        // Grid
        gridStack.axis = .vertical
        gridStack.spacing = 24
        gridStack.translatesAutoresizingMaskIntoConstraints = false
        gridStack.isHidden = true
        contentView.addSubview(gridStack)
        NSLayoutConstraint.activate([
            gridStack.topAnchor.constraint(equalTo: separator.bottomAnchor, constant: 24),
            gridStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            gridStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            gridStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    private func reloadData() {
        emptyStateStack.isHidden = !rolls.isEmpty
        gridStack.isHidden = rolls.isEmpty

        if !rolls.isEmpty {
            gridStack.arrangedSubviews.forEach {
                gridStack.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }

            let itemsPerRow = UIDevice.current.userInterfaceIdiom == .pad ? 4 : 3
            var currentRow: UIStackView?

            for (index, roll) in rolls.enumerated() {
                if index % itemsPerRow == 0 {
                    currentRow = UIStackView()
                    currentRow!.axis = .horizontal
                    currentRow!.distribution = .fillEqually
                    currentRow!.spacing = 16
                    currentRow!.translatesAutoresizingMaskIntoConstraints = false
                    gridStack.addArrangedSubview(currentRow!)
                }

                let canister = CanisterView()
                canister.label = roll.name
                canister.filmType = roll.type
                canister.onTap = { [weak self] in
                    guard let self = self else { return }
                    let detailVC = RollDetailViewController(roll: roll)
                    self.navigationController?.pushViewController(detailVC, animated: true)
                }
                canister.translatesAutoresizingMaskIntoConstraints = false
                canister.heightAnchor.constraint(equalToConstant: 160).isActive = true
                currentRow?.addArrangedSubview(canister)
            }
        }
    }

    func setRolls(_ rolls: [Roll]) {
        self.rolls = rolls
        reloadData()
    }

    @objc private func didTapAbout() {
        onOpenAbout?()
    }

    @objc private func didTapUpload() {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0
        config.filter = .images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }
}

extension HomeViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard !results.isEmpty else { return }
        var images: [UIImage] = []
        let group = DispatchGroup()

        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                if let image = object as? UIImage {
                    images.append(image)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            self?.onCreateNew?(images)
        }
    }
}

// MARK: - Empty State Views

class EmptyStateIconView: UIView {
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
        let ink = Theme.ink.withAlphaComponent(0.4)
        let s = min(rect.width, rect.height) / 24.0
        let ox = (rect.width - 24*s)/2
        let oy = (rect.height - 24*s)/2

        context.saveGState()
        context.translateBy(x: ox, y: oy)
        context.scaleBy(x: s, y: s)

        ink.setStroke()
        context.setLineWidth(1.0)
        context.setLineCap(.round)
        context.setLineJoin(.round)

        let rectPath = UIBezierPath()
        rectPath.move(to: CGPoint(x: 3, y: 3))
        rectPath.addLine(to: CGPoint(x: 21, y: 3))
        rectPath.addLine(to: CGPoint(x: 21, y: 21))
        rectPath.addLine(to: CGPoint(x: 3, y: 21))
        rectPath.close()
        context.addPath(rectPath.cgPath)
        context.strokePath()

        let circle = UIBezierPath(ovalIn: CGRect(x: 7, y: 7, width: 3, height: 3))
        context.addPath(circle.cgPath)
        context.strokePath()

        let poly = UIBezierPath()
        poly.move(to: CGPoint(x: 21, y: 15))
        poly.addLine(to: CGPoint(x: 16, y: 10))
        poly.addLine(to: CGPoint(x: 5, y: 21))
        context.addPath(poly.cgPath)
        context.strokePath()

        context.restoreGState()
    }
}

class ArrowIconView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }

    override func draw(_ rect: CGRect) {
        let ink = Theme.ink.withAlphaComponent(0.5)
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.midX - 15, y: rect.midY - 5))
        path.addLine(to: CGPoint(x: rect.midX + 15, y: rect.midY - 5))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.midY + 15))
        ink.setStroke()
        path.lineWidth = 4
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        path.stroke()
    }
}
