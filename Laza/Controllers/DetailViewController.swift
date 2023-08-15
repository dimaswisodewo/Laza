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
            cartButton.addTarget(self, action: #selector(cartButtonPressed), for: .touchUpInside)
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
    
    private let sizes = ["S", "M", "L", "XL", "2XL"]
    
    private var product: Product?
    private var viewModel: DetailViewModel?
    private let emptyCellIdentifier = "EmptyCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        
        loadProductDetail()
        
        // Reload table view, wait 0.1 sec to make sure that collection views inside the table view is finished layouting subviews
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    private func loadProductDetail() {
        // Assign reload table view on finished load API
        viewModel?.reloadProductDetailCollectionView = { [weak self] in
            self?.tableView.reloadData()
        }
        // Load necessary data
        viewModel?.loadProductDetail()
        viewModel?.loadRatings()
    }
    
    private func registerCells() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        tableView.register(ReviewTableViewCell.nib, forCellReuseIdentifier: ReviewTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: emptyCellIdentifier)
    }
    
    func configure(product: Product) {
        self.product = product
        self.viewModel = DetailViewModel(productId: product.id)
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func cartButtonPressed() {
        
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
            tableViewCell.delegate = self
            return tableViewCell
        case Row.Review.rawValue:
            // There are no review for the product
            if let reviews = viewModel?.productReviews?.reviews, reviews.isEmpty {
                guard let emptyCell = tableView.dequeueReusableCell(withIdentifier: emptyCellIdentifier) else {
                    return UITableViewCell()
                }
                
                let label = UILabel()
                label.text = "There are no review"
                label.textAlignment = .center
                label.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14)
                
                emptyCell.contentView.addSubview(label)
                label.frame = emptyCell.contentView.bounds
                
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
        
        guard let reviews = viewModel?.productReviews else { return }
        guard let productId = viewModel?.productDetail?.id else { return }
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: AllReviewsViewController.identifier) as? AllReviewsViewController else { return }
        
        vc.configure(productId: productId, reviews: reviews)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func productThumbnailCellForItemAt(productCell cell: DetailThumbnailCollectionViewCell, cellForItemAt indexPath: IndexPath) {
        
        guard let product = product else {
            print("Product model is nil")
            return
        }
        
        cell.productImageView.loadAndCache(url: product.imageUrl)
    }
    
    func applyModel(productImage: UIImageView, productName: UILabel, productCategory: UILabel, productPrice: UILabel, productDesc: UILabel) {
        
        guard let product = product else {
            print("Product model is nil")
            return
        }
        
        productImage.loadAndCache(url: product.imageUrl)
        productName.text = product.name.capitalized
        if let categories = viewModel?.productDetail?.category {
            let categoryText = categories.map { $0.category.capitalized }.joined(separator: ", ")
            productCategory.text = categoryText
        }
        if let productDetail = viewModel?.productDetail {
            productDesc.text = productDetail.description
        }
        productPrice.text = "$\(product.price)".formatDecimal()
    }
}
