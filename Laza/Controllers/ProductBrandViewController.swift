//
//  ProductBrandViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 08/08/23.
//

import UIKit
import SkeletonView

class ProductBrandViewController: UIViewController {

    static let identifier = "ProductBrandViewController"
    
    @IBOutlet weak var brandLabel: UILabel!
    
    @IBOutlet weak var productsCountLabel: UILabel!
    
    @IBOutlet weak var availableInStockLabel: UILabel!
    
    @IBOutlet weak var sortButton: RoundedButton!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20)
        }
    }
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var rightButton: CircleButton! {
        didSet {
            let image = rightButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            rightButton.setImage(image, for: .normal)
            rightButton.tintColor = ColorUtils.shared.getColor(color: .TextPrimary)
        }
    }
    
    
    private var viewModel: ProductBrandViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        registerCell()
        setupRefreshControl()
        setupSkeleton()
        showSkeleton()
            
        brandLabel.text = viewModel.brandName
        
        loadProductsByBrand()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    private func setupSkeleton() {
        collectionView.isSkeletonable = true
        productsCountLabel.isSkeletonable = true
        availableInStockLabel.isSkeletonable = true
        sortButton.isSkeletonable = true
    }
    
    private func showSkeleton() {
        collectionView.showAnimatedGradientSkeleton()
        productsCountLabel.showAnimatedGradientSkeleton()
        availableInStockLabel.showAnimatedGradientSkeleton()
        sortButton.showAnimatedGradientSkeleton()
    }
    
    private func hideSkeleton() {
        collectionView.hideSkeleton()
        productsCountLabel.hideSkeleton()
        availableInStockLabel.hideSkeleton()
        sortButton.hideSkeleton()
    }
    
    private func setupRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        loadProductsByBrand(onFinished: {
            // Dismiss the refresh control
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.collectionView.refreshControl?.endRefreshing()
            }
        })
    }
    
    private func loadProductsByBrand(onFinished: (() -> Void)? = nil) {
        viewModel.loadProductsByBrand(completion: { productsCount in
            DispatchQueue.main.async { [weak self] in
                self?.hideSkeleton()
                self?.productsCountLabel.text = "\(productsCount) Items"
                self?.collectionView.reloadData()
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
    
    func configure(brandName: String) {
        viewModel = ProductBrandViewModel(brandName: brandName)
    }
    
    private func registerCell() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UIColectionView DataSource

extension ProductBrandViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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

// MARK: - SkeletonCollectionView DataSource

extension ProductBrandViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return ProductCollectionViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, skeletonCellForItemAt indexPath: IndexPath) -> UICollectionViewCell? {
        guard let cell = skeletonView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.showSkeleton()
        return cell
    }
}
