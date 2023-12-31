//
//  DetailTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 02/08/23.
//

import UIKit
import SkeletonView

protocol DetailTableViewCellDelegate: AnyObject {
    
    func applyModel(productImage: UIImageView, productName: UILabel, productCategory: UILabel, productPrice: UILabel, productDesc: UILabel, completion: () -> Void)
    
    func productThumbnailCellForItemAt(productCell cell: DetailThumbnailCollectionViewCell, cellForItemAt indexPath: IndexPath)
    
    func productSizeCellForItemAt(sizeCell cell: DetailSizeCollectionViewCell, cellForItemAt indexPath: IndexPath)
    
    func didSelectProductSizeCell(sizeCell cell: DetailSizeCollectionViewCell, didSelectItemAt indexPath: IndexPath)
    
    func sizeNumberOfItemsInSection() -> Int
    
    func viewAllReviewsButtonPressed()
}

enum DetailCollectionTag: Int {
    case product = 0
    case size = 1
}

class DetailTableViewCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    
    weak var delegate: DetailTableViewCellDelegate?
    
    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.numberOfLines = 0
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 16)
        label.textColor = ColorUtils.shared.getColor(color: .TextSecondary)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Product name"
        label.numberOfLines = 0
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 24)
        label.textColor = ColorUtils.shared.getColor(color: .TextPrimary)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "Price"
        label.textAlignment = .right
        label.numberOfLines = 0
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 16)
        label.textColor = ColorUtils.shared.getColor(color: .TextSecondary)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let priceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "$0"
        label.textAlignment = .right
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 24)
        label.textColor = ColorUtils.shared.getColor(color: .TextPrimary)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.text = "Size"
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 18)
        label.textColor = ColorUtils.shared.getColor(color: .TextPrimary)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 18)
        label.textColor = ColorUtils.shared.getColor(color: .TextPrimary)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
        label.numberOfLines = 0
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14)
        label.textColor = ColorUtils.shared.getColor(color: .TextSecondary)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reviewsLabel: UILabel = {
        let label = UILabel()
        label.text = "Reviews"
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 18)
        label.textColor = ColorUtils.shared.getColor(color: .TextPrimary)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let viewAllReviewsButton: UIButton = {
        let button = UIButton()
        button.setTitle("View All", for: .normal)
        button.titleLabel?.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 16)
        button.titleLabel?.textAlignment = .right
        button.setTitleColor(ColorUtils.shared.getColor(color: .TextSecondary), for: .normal)
        button.addTarget(self, action: #selector(viewAllReviewsButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let productCollectionView: DynamicHeightCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 80, height: 80)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let cv = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = ColorUtils.shared.getColor(color: .WhiteBG)
        cv.tag = DetailCollectionTag.product.rawValue
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let sizeCollectionView: DynamicHeightCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: 60, height: 60)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        let cv = DynamicHeightCollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = ColorUtils.shared.getColor(color: .WhiteBG)
        cv.tag = DetailCollectionTag.size.rawValue
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.backgroundColor = ColorUtils.shared.getColor(color: .WhiteBG)
        
        contentView.addSubview(productImageView)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(priceValueLabel)
        contentView.addSubview(productCollectionView)
        contentView.addSubview(sizeLabel)
        contentView.addSubview(sizeCollectionView)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(descriptionValueLabel)
        contentView.addSubview(reviewsLabel)
        contentView.addSubview(viewAllReviewsButton)
        
        setupConstraint()
        
        registerCells()
        
        setupSkeleton()
        showSkeleton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        delegate?.applyModel(
            productImage: productImageView,
            productName: nameLabel,
            productCategory: categoryLabel,
            productPrice: priceValueLabel,
            productDesc: descriptionValueLabel,
            completion: hideSkeleton
        )
    }
    
    @objc private func viewAllReviewsButtonPressed() {
        delegate?.viewAllReviewsButtonPressed()
    }
    
    private func registerCells() {
        sizeCollectionView.dataSource = self
        sizeCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.delegate = self
        sizeCollectionView.register(DetailSizeCollectionViewCell.self, forCellWithReuseIdentifier: DetailSizeCollectionViewCell.identifier)
        productCollectionView.register(DetailThumbnailCollectionViewCell.self, forCellWithReuseIdentifier: DetailThumbnailCollectionViewCell.identifier)
    }
    
    private func setupSkeleton() {
        productImageView.isSkeletonable = true
        categoryLabel.isSkeletonable = true
        nameLabel.isSkeletonable = true
        priceLabel.isSkeletonable = true
        priceValueLabel.isSkeletonable = true
        sizeLabel.isSkeletonable = true
        descriptionLabel.isSkeletonable = true
        descriptionValueLabel.isSkeletonable = true
        reviewsLabel.isSkeletonable = true
        viewAllReviewsButton.isSkeletonable = true
        sizeCollectionView.isSkeletonable = true
    }
    
    private func showSkeleton() {
        productImageView.showAnimatedGradientSkeleton()
        categoryLabel.showAnimatedGradientSkeleton()
        nameLabel.showAnimatedGradientSkeleton()
        priceLabel.showAnimatedGradientSkeleton()
        priceValueLabel.showAnimatedGradientSkeleton()
        sizeLabel.showAnimatedGradientSkeleton()
        descriptionLabel.showAnimatedGradientSkeleton()
        descriptionValueLabel.showAnimatedGradientSkeleton()
        reviewsLabel.showAnimatedGradientSkeleton()
        viewAllReviewsButton.showAnimatedGradientSkeleton()
        sizeCollectionView.showAnimatedGradientSkeleton()
    }
    
    private func hideSkeleton() {
        productImageView.hideSkeleton()
        categoryLabel.hideSkeleton()
        nameLabel.hideSkeleton()
        priceLabel.hideSkeleton()
        priceValueLabel.hideSkeleton()
        sizeLabel.hideSkeleton()
        descriptionLabel.hideSkeleton()
        descriptionValueLabel.hideSkeleton()
        reviewsLabel.hideSkeleton()
        viewAllReviewsButton.hideSkeleton()
        sizeCollectionView.hideSkeleton()
    }
    
    private func setupConstraint() {
        // Product image view
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: 450)
        ])
        // Product category label
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 20),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            categoryLabel.trailingAnchor.constraint(equalTo: priceLabel.leadingAnchor)
        ])
        // Price title label
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: categoryLabel.topAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            priceLabel.widthAnchor.constraint(equalToConstant: 100)
        ])
        // Product name label
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: priceValueLabel.leadingAnchor)
        ])
        // Price value label
        NSLayoutConstraint.activate([
            priceValueLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            priceValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            priceValueLabel.widthAnchor.constraint(equalToConstant: 160)
        ])
        // Product collection view
        NSLayoutConstraint.activate([
            productCollectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 24),
            productCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            productCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            productCollectionView.heightAnchor.constraint(equalToConstant: 80)
        ])
        // Size title label
        NSLayoutConstraint.activate([
            sizeLabel.topAnchor.constraint(equalTo: productCollectionView.bottomAnchor, constant: 24),
            sizeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
        // Size collection view
        NSLayoutConstraint.activate([
            sizeCollectionView.topAnchor.constraint(equalTo: sizeLabel.bottomAnchor, constant: 8),
            sizeCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            sizeCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            sizeCollectionView.heightAnchor.constraint(equalToConstant: 60)
        ])
        // Description label
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: sizeCollectionView.bottomAnchor, constant: 24),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
        // Description value label
        NSLayoutConstraint.activate([
            descriptionValueLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionValueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionValueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
        // Reviews label
        NSLayoutConstraint.activate([
            reviewsLabel.topAnchor.constraint(equalTo: descriptionValueLabel.bottomAnchor, constant: 24),
            reviewsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reviewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            reviewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14)
        ])
        // View All Reviews button
        NSLayoutConstraint.activate([
            viewAllReviewsButton.topAnchor.constraint(equalTo: reviewsLabel.topAnchor),
            viewAllReviewsButton.bottomAnchor.constraint(equalTo: reviewsLabel.bottomAnchor),
            viewAllReviewsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            viewAllReviewsButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 10)
        ])
    }
}

// MARK: - UICollectionView DataSource & Delegate

extension DetailTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case DetailCollectionTag.product.rawValue:
            return 1
        case DetailCollectionTag.size.rawValue:
            return delegate?.sizeNumberOfItemsInSection() ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case DetailCollectionTag.product.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailThumbnailCollectionViewCell.identifier, for: indexPath) as? DetailThumbnailCollectionViewCell else {
                print("Failed to dequeue DetailThumbnailCollectionViewCell")
                return UICollectionViewCell()
            }
            delegate?.productThumbnailCellForItemAt(productCell: cell, cellForItemAt: indexPath)
            return cell
        case DetailCollectionTag.size.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailSizeCollectionViewCell.identifier, for: indexPath) as? DetailSizeCollectionViewCell else {
                print("Failed to dequeue DetailSizeCollectionViewCell")
                return UICollectionViewCell()
            }
            delegate?.productSizeCellForItemAt(sizeCell: cell, cellForItemAt: indexPath)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        switch collectionView.tag {
        case DetailCollectionTag.size.rawValue:
            guard let cell = collectionView.cellForItem(at: indexPath) as? DetailSizeCollectionViewCell else { return }
            delegate?.didSelectProductSizeCell(sizeCell: cell, didSelectItemAt: indexPath)
        default:
            break
        }
    }
}

// MARK: - SkeletonCollectionViewDataSource

extension DetailTableViewCell: SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return DetailSizeCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: DetailSizeCollectionViewCell.identifier, for: indexPath) as? DetailSizeCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.showSkeleton()
        return cell
    }
}
