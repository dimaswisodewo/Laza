//
//  WishlistViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

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
    
    private let viewModel = WishlistViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarItemImage()
        
        viewModel.reloadProductCollectionView = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.loadProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
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
