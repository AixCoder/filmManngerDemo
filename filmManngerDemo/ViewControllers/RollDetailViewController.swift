import UIKit

class RollDetailViewController: UIViewController {
    private var roll: Roll

    private var collectionView: UICollectionView!
    private var headerHeight: CGFloat = 180

    var onBack: (() -> Void)?
    var onContactSheet: (() -> Void)?
    var onEdit: (() -> Void)?

    init(roll: Roll) {
        self.roll = roll
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.paper
        setupCollectionView()

        // 后台加载 Bundle 中的真实照片
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            BundleImageLoader.printBundleContents() // 调试：打印 Bundle 目录结构
            let realImages = BundleImageLoader.loadImages()

            DispatchQueue.main.async {
                guard let self = self else { return }
                if realImages.isEmpty {
                    print("[RollDetail] Bundle 中未找到任何 jpg 图片，继续展示模拟数据")
                    return
                }
                let photos = realImages.enumerated().map { index, image in
                    Photo(id: "bundle-\(index)", image: image)
                }
                self.roll.photos = photos
                self.collectionView.reloadData()
            }
        }

        collectionView.alpha = 0
        collectionView.transform = CGAffineTransform(translationX: 0, y: 20)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut], animations: {
            self.collectionView.alpha = 1
            self.collectionView.transform = .identity
        })
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 24, bottom: 24, right: 24)
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: headerHeight)

        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        collectionView.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseId)
        collectionView.register(RollDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: RollDetailHeaderView.reuseId)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let itemsPerRow: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 5 : 3
        let totalSpacing: CGFloat = 48 + (itemsPerRow - 1) * 16
        let itemWidth = floor((view.bounds.width - totalSpacing) / itemsPerRow)
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: headerHeight)
    }

    @objc private func didTapBack() {
        onBack?()
        navigationController?.popViewController(animated: true)
    }

    @objc private func didTapEdit() {
        onEdit?()
    }

    @objc private func didTapContactSheet() {
        onContactSheet?()
        let contactSheetVC = ContactSheetViewController(roll: roll)
        contactSheetVC.modalPresentationStyle = .fullScreen
        present(contactSheetVC, animated: true)
    }
}

extension RollDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roll.photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCell.reuseId, for: indexPath) as! PhotoCell
        let photo = roll.photos[indexPath.item]
        cell.configure(with: photo, index: indexPath.item)
        cell.animateEntrance(delay: Double(indexPath.item) * 0.05)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else { return UICollectionReusableView() }
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: RollDetailHeaderView.reuseId, for: indexPath) as! RollDetailHeaderView
        header.configure(with: roll)
        header.onBack = { [weak self] in self?.didTapBack() }
        header.onEdit = { [weak self] in self?.didTapEdit() }
        header.onContactSheet = { [weak self] in self?.didTapContactSheet() }
        return header
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Handle photo tap if needed
    }
}
