//
//  DetailViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 28/07/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    enum Row: Int, CaseIterable {
        case Detail = 0
        case Review = 1
    }
    
    static let identifier = "DetailViewController"
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var cartButton: CircleButton! {
        didSet {
            let image = cartButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            cartButton.setImage(image, for: .normal)
            cartButton.tintColor = ColorUtils.shared.getColor(color: .TextPrimary)
            cartButton.addTarget(self, action: #selector(wishlistButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var addToCartButton: UIButton! {
        didSet {
            addToCartButton.addTarget(self, action: #selector(addToCartButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var tableView: IntrinsicTableView! {
        didSet {
            tableView.backgroundColor = ColorUtils.shared.getColor(color: .WhiteBG)
            tableView.showsVerticalScrollIndicator = false
            tableView.separatorStyle = .none
            tableView.allowsSelection = false
        }
    }
    
    private var detailTableViewCell: DetailTableViewCell?
    private var viewModel: DetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        
        cartButton.isEnabled = false
        
        loadProductDetail()
        loadIsWishlisted()
        
        registerObserver()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    // Remove observer to reload reviews
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.newReviewAdded, object: nil)
    }
    
    // Register observer to reload reviews when there are new review added
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(loadRatings), name: Notification.Name.newReviewAdded, object: nil)
    }
    
    @objc private func loadRatings() {
        print("Reload ratings in DetailViewController")
        viewModel?.loadRatings()
    }
    
    private func loadProductDetail() {
        // Assign reload table view on finished load API
        viewModel?.reloadProductDetailCollectionView = { [weak self] in
            self?.tableView.reloadData()
            self?.detailTableViewCell?.sizeCollectionView.reloadData()
            self?.detailTableViewCell?.productCollectionView.reloadData()
        }
        // Load necessary data
        viewModel?.loadProductDetail()
        viewModel?.loadRatings()
    }
    
    private func loadIsWishlisted() {
        viewModel?.loadIsWishlisted(completion: { isWishlisted in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let systemName = isWishlisted ? "heart.fill" : "heart"
                self.cartButton.setImage(UIImage(systemName: systemName), for: .normal)
                self.cartButton.isEnabled = true
            }
        }, onError: { errorMessage in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.cartButton.isEnabled = true
                SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
            }
        })
    }
    
    private func registerCells() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.register(ReviewTableViewCell.nib, forCellReuseIdentifier: ReviewTableViewCell.identifier)
        tableView.register(EmptyTableViewCell.nib, forCellReuseIdentifier: EmptyTableViewCell.identifier)
    }
    
    func configure(productId: Int) {
        self.viewModel = DetailViewModel(productId: productId)
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func wishlistButtonPressed() {
        
        guard let isLoading = viewModel?.isWishlistLoading else { return }
        if isLoading { return }
        
        cartButton.isEnabled = false
        
        viewModel?.toggleWishlist(completion: { isWishlisted in
            NotificationCenter.default.post(name: .wishlistUpdated, object: nil)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let systemName = isWishlisted ? "heart.fill" : "heart"
                self.cartButton.setImage(UIImage(systemName: systemName), for: .normal)
                self.cartButton.isEnabled = true
                let message = isWishlisted ? "Added to wishlist" : "Remove from wishlist"
                SnackBarSuccess.make(in: self.view, message: message, duration: .lengthShort).show()
            }
        }, onError: { errorMessage in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.cartButton.isEnabled = true
                SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
            }
        })
    }
    
    @objc private func addToCartButtonPressed() {
        
    }
}

// MARK: - UITableView DataSource & Delegate

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Row.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case Row.Detail.rawValue:
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier) as? DetailTableViewCell else {
                print("Failed to dequeue DetailTableViewCell")
                return UITableViewCell()
            }
            detailTableViewCell = tableViewCell // Cache to reload size collection view
            tableViewCell.delegate = self
            return tableViewCell
        case Row.Review.rawValue:
            // There are no review for the product
            if viewModel?.productReviews?.reviews.isEmpty ?? true {
                guard let emptyCell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.identifier) as? EmptyTableViewCell else {
                    return UITableViewCell()
                }
                emptyCell.setTitle(title: "There are no reviews for this product")
                return emptyCell
            }
            // There is at least one review for the product
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ReviewTableViewCell.identifier) as? ReviewTableViewCell else {
                print("Failed to dequeue ReviewTableViewCell")
                return UITableViewCell()
            }
            if let review = viewModel?.productReviews?.reviews.first {
                tableViewCell.configureReview(model: review)
            }
            return tableViewCell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - DetailTableViewCellDelegate

extension DetailViewController: DetailTableViewCellDelegate {
    
    func viewAllReviewsButtonPressed() {
        
        guard let productId = viewModel?.productDetail?.id else { return }
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: AllReviewsViewController.identifier) as? AllReviewsViewController else { return }
        
        vc.configure(productId: productId, reviews: viewModel?.productReviews)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func sizeNumberOfItemsInSection() -> Int {
        return viewModel?.productDetail?.size.count ?? 0
    }
    
    func productThumbnailCellForItemAt(productCell cell: DetailThumbnailCollectionViewCell, cellForItemAt indexPath: IndexPath) {
        guard let product = viewModel?.productDetail else { return }
        cell.productImageView.loadAndCache(url: product.imageUrl)
    }
    
    func productSizeCellForItemAt(productCell cell: DetailSizeCollectionViewCell, cellForItemAt indexPath: IndexPath) {
        guard let size = viewModel?.productDetail?.size[indexPath.item] else { return }
        cell.configureSize(size: size.size)
    }
    
    func applyModel(productImage: UIImageView, productName: UILabel, productCategory: UILabel, productPrice: UILabel, productDesc: UILabel) {
        
        guard let product = viewModel?.productDetail else { return }
        
        productImage.loadAndCache(url: product.imageUrl)
        productName.text = product.name.capitalized
        if let category = viewModel?.productDetail?.category {
            productCategory.text = category.category
        }
        if let productDetail = viewModel?.productDetail {
            productDesc.text = productDetail.description
        }
        productPrice.text = "$\(product.price)".formatDecimal()
    }
}
