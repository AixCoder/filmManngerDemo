import UIKit

class ContactSheetViewController: UIViewController {
    private var roll: Roll

    private let topBar = UIView()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let drawingOverlay = DrawingOverlayView()

    private let closeButton = UIButton(type: .system)
    private let titleLabel = UILabel()
    private let browseButton = UIButton(type: .system)
    private let drawButton = UIButton(type: .system)
    private let clearButton = UIButton(type: .system)
    private let saveButton = SketchButton()

    private var isDrawingMode = false

    init(roll: Roll) {
        self.roll = roll
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1)
        setupTopBar()
        setupScrollView()
        setupFilmStrips()
    }

    private func setupTopBar() {
        topBar.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(topBar)

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = "\(roll.name) - 接触印象"
        titleLabel.font = UIFont(name: "Marker Felt", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let toolsContainer = UIView()
        toolsContainer.backgroundColor = UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1)
        toolsContainer.layer.cornerRadius = 4
        toolsContainer.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        toolsContainer.layer.borderWidth = 1
        toolsContainer.translatesAutoresizingMaskIntoConstraints = false

        browseButton.setTitle(" 浏览", for: .normal)
        browseButton.setImage(UIImage(systemName: "cursorarrow"), for: .normal)
        browseButton.titleLabel?.font = UIFont(name: "Marker Felt", size: 14) ?? UIFont.systemFont(ofSize: 14)
        browseButton.addTarget(self, action: #selector(didTapBrowse), for: .touchUpInside)
        browseButton.translatesAutoresizingMaskIntoConstraints = false
        browseButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        drawButton.setTitle(" 红笔圈选", for: .normal)
        drawButton.setImage(UIImage(systemName: "pencil"), for: .normal)
        drawButton.titleLabel?.font = UIFont(name: "Marker Felt", size: 14) ?? UIFont.systemFont(ofSize: 14)
        drawButton.addTarget(self, action: #selector(didTapDraw), for: .touchUpInside)
        drawButton.translatesAutoresizingMaskIntoConstraints = false
        drawButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)

        let toolsStack = UIStackView(arrangedSubviews: [browseButton, drawButton])
        toolsStack.axis = .horizontal
        toolsStack.spacing = 0
        toolsStack.translatesAutoresizingMaskIntoConstraints = false
        toolsContainer.addSubview(toolsStack)

        clearButton.setImage(UIImage(systemName: "eraser"), for: .normal)
        clearButton.tintColor = UIColor.gray
        clearButton.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.isHidden = true

        saveButton.setTitle(" 保存图像", for: .normal)
        saveButton.setImage(UIImage(systemName: "arrow.down.circle"), for: .normal)
        saveButton.variant = .primary
        saveButton.sketchSize = .sm
        saveButton.backgroundColor = UIColor(red: 250/255, green: 204/255, blue: 21/255, alpha: 1)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        let leftStack = UIStackView(arrangedSubviews: [closeButton, titleLabel])
        leftStack.axis = .horizontal
        leftStack.spacing = 12
        leftStack.alignment = .center
        leftStack.translatesAutoresizingMaskIntoConstraints = false

        let centerStack = UIStackView(arrangedSubviews: [toolsContainer, clearButton])
        centerStack.axis = .horizontal
        centerStack.spacing = 8
        centerStack.alignment = .center
        centerStack.translatesAutoresizingMaskIntoConstraints = false

        let mainStack = UIStackView(arrangedSubviews: [leftStack, centerStack, saveButton])
        mainStack.axis = .horizontal
        mainStack.distribution = .equalSpacing
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        topBar.addSubview(mainStack)

        NSLayoutConstraint.activate([
            topBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBar.heightAnchor.constraint(equalToConstant: 60),

            mainStack.topAnchor.constraint(equalTo: topBar.topAnchor, constant: 8),
            mainStack.leadingAnchor.constraint(equalTo: topBar.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: topBar.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: topBar.bottomAnchor, constant: -8),

            toolsStack.topAnchor.constraint(equalTo: toolsContainer.topAnchor, constant: 4),
            toolsStack.leadingAnchor.constraint(equalTo: toolsContainer.leadingAnchor, constant: 4),
            toolsStack.trailingAnchor.constraint(equalTo: toolsContainer.trailingAnchor, constant: -4),
            toolsStack.bottomAnchor.constraint(equalTo: toolsContainer.bottomAnchor, constant: -4),

            closeButton.widthAnchor.constraint(equalToConstant: 44),
            closeButton.heightAnchor.constraint(equalToConstant: 44)
        ])

        updateToolButtons()
    }

    private func setupScrollView() {
        scrollView.backgroundColor = UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView.backgroundColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 16),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16)
        ])

        drawingOverlay.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(drawingOverlay)
        NSLayoutConstraint.activate([
            drawingOverlay.topAnchor.constraint(equalTo: contentView.topAnchor),
            drawingOverlay.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            drawingOverlay.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            drawingOverlay.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    private func setupFilmStrips() {
        let chunkCount = 6
        var chunks: [[Photo]] = []
        for i in stride(from: 0, to: roll.photos.count, by: chunkCount) {
            let end = min(i + chunkCount, roll.photos.count)
            chunks.append(Array(roll.photos[i..<end]))
        }

        var previousView: UIView?

        for (index, chunk) in chunks.enumerated() {
            let strip = FilmStrip135View()
            strip.photos = chunk
            strip.startIndex = index * chunkCount
            strip.filmType = roll.type
            strip.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(strip)

            let photoCount = max(chunk.count, 6)
            let singleWidth: CGFloat = 225 // 150 * 1.5
            let stripWidth = CGFloat(photoCount) * singleWidth + CGFloat(max(0, photoCount - 1)) * 4 + 32

            var constraints: [NSLayoutConstraint] = [
                strip.topAnchor.constraint(equalTo: previousView?.bottomAnchor ?? contentView.topAnchor, constant: 8),
                strip.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                strip.widthAnchor.constraint(equalToConstant: stripWidth),
                strip.heightAnchor.constraint(equalToConstant: 260)
            ]

            // 第一条 strip 定义 contentView 的宽度，使 scrollView 能正确推导 contentSize
            if index == 0 {
                constraints.append(strip.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16))
            }

            NSLayoutConstraint.activate(constraints)
            previousView = strip
        }

        if let last = previousView {
            last.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16).isActive = true
        } else {
            let emptyLabel = UILabel()
            emptyLabel.text = "先冲洗一卷胶卷，再来查看接触印象吧。"
            emptyLabel.font = UIFont(name: "Marker Felt", size: 24) ?? UIFont.boldSystemFont(ofSize: 24)
            emptyLabel.textColor = UIColor.gray
            emptyLabel.textAlignment = .center
            emptyLabel.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(emptyLabel)
            NSLayoutConstraint.activate([
                emptyLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                emptyLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                emptyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 40),
                emptyLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -40)
            ])
            emptyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40).isActive = true
        }

        contentView.bringSubviewToFront(drawingOverlay)
    }

    @objc private func didTapClose() {
        dismiss(animated: true)
    }

    @objc private func didTapBrowse() {
        isDrawingMode = false
        updateToolButtons()
    }

    @objc private func didTapDraw() {
        isDrawingMode = true
        updateToolButtons()
    }

    @objc private func didTapClear() {
        drawingOverlay.clear()
    }

    @objc private func didTapSave() {
        let renderer = UIGraphicsImageRenderer(bounds: contentView.bounds)
        let image = renderer.image { context in
            contentView.layer.render(in: context.cgContext)
        }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("保存失败: \(error.localizedDescription)")
        } else {
            print("接触印象已保存到相册")
        }
    }

    private func updateToolButtons() {
        browseButton.backgroundColor = isDrawingMode ? UIColor.clear : UIColor.white
        browseButton.setTitleColor(isDrawingMode ? UIColor.gray : UIColor.black, for: .normal)
        browseButton.tintColor = isDrawingMode ? UIColor.gray : UIColor.black
        browseButton.layer.cornerRadius = isDrawingMode ? 0 : 4

        drawButton.backgroundColor = isDrawingMode ? UIColor(red: 239/255, green: 68/255, blue: 68/255, alpha: 1) : UIColor.clear
        drawButton.setTitleColor(isDrawingMode ? UIColor.white : UIColor.gray, for: .normal)
        drawButton.tintColor = isDrawingMode ? UIColor.white : UIColor.gray
        drawButton.layer.cornerRadius = isDrawingMode ? 4 : 0

        clearButton.isHidden = !isDrawingMode
        drawingOverlay.isDrawingEnabled = isDrawingMode
    }
}
