//
//  WishlistViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit
import SkeletonView

class WishlistViewController: UIViewController {

    static let identifier = "WishlistViewController"
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 24, right: 20)
            collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        }
    }
    
    @IBOutlet weak var wishlistCountLabel: UILabel! {
        didSet {
            wishlistCountLabel.text = "0 Items"
        }
    }
    
    @IBOutlet weak var availableInStockLabel: UILabel!
    
    @IBOutlet weak var sortButton: RoundedButton! {
        didSet {
            sortButton.addTarget(self, action: #selector(sortButtonPressed), for: .touchUpInside)
        }
    }
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "You have no wishlist"
        label.textAlignment = .center
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14)
        label.textColor = ColorUtils.shared.getColor(color: .TextPrimary)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewModel = WishlistViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarItemImage()
        setupEmptyLabel()
        setupRefreshControl()
        registerObserver()
        
        setupSkeleton()
        showSkeleton()
        
        loadWishlists()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.wishlistUpdated, object: nil)
    }
    
    private func setIsWishlistEmpty(isEmpty: Bool) {
        emptyLabel.isHidden = !isEmpty
        wishlistCountLabel.isHidden = isEmpty
        availableInStockLabel.isHidden = isEmpty
        sortButton.isHidden = isEmpty
    }
    
    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        let insets = view.safeAreaInsets
        NSLayoutConstraint.activate([
            emptyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ])
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifyLoadWishlist), name: Notification.Name.wishlistUpdated, object: nil)
    }
    
    private func setupSkeleton() {
        wishlistCountLabel.isSkeletonable = true
        availableInStockLabel.isSkeletonable = true
        sortButton.isSkeletonable = true
        collectionView.isSkeletonable = true
    }
    
    private func showSkeleton() {
        wishlistCountLabel.showAnimatedGradientSkeleton()
        availableInStockLabel.showAnimatedGradientSkeleton()
        sortButton.showAnimatedGradientSkeleton()
        collectionView.showAnimatedGradientSkeleton()
    }
    
    private func hideSkeleton() {
        wishlistCountLabel.hideSkeleton()
        availableInStockLabel.hideSkeleton()
        sortButton.hideSkeleton()
        collectionView.hideSkeleton()
    }
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Wishlist"
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 12)
        label.sizeToFit()
        
        navigationController?.tabBarItem.selectedImage = UIImage(view: label)
    }
    
    private func setupRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        loadWishlists(onFinished: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.collectionView.refreshControl?.endRefreshing()
            }
        })
    }
    
    private func loadWishlists(onFinished: (() -> Void)? = nil) {
        viewModel.loadWishlists(completion: {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.collectionView.reloadData()
                self.hideSkeleton()
                self.wishlistCountLabel.text = "\(self.viewModel.productsCount) Items"
                self.setIsWishlistEmpty(isEmpty: self.viewModel.productsCount == 0)
            }
            onFinished?()
        }, onError: { errorMessage in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
            }
            onFinished?()
        })
    }
    
    @objc private func onNotifyLoadWishlist() {
        loadWishlists()
    }
    
    @objc private func sortButtonPressed() {
        viewModel.toggleSortItem()
        collectionView.reloadData()
    }
}

extension WishlistViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.productsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let product = viewModel.getProductOnIndex(index: indexPath.item) {
            cell.hideSkeleton()
            cell.configure(product: product)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController else {
            return
        }
        guard let product = viewModel.getProductOnIndex(index: indexPath.item) else { return }
        vc.configure(productId: product.id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let contentInset: CGFloat = 40 // EdgeInsets left & right of ProductCollectionView
        let numOfColum: CGFloat = 2.0
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let collectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let spacing = layout.minimumInteritemSpacing * (numOfColum - 1) + collectionViewFlowLayout.sectionInset.left + collectionViewFlowLayout.sectionInset.right + contentInset
        let width = (collectionView.frame.size.width / numOfColum ) - spacing
        let cellHeightToWidthAspectRatio = CGFloat(250) / CGFloat(160)
        return CGSize(width: width, height: width * cellHeightToWidthAspectRatio)
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension WishlistViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return ProductCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.showSkeleton()
        return cell
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
}
