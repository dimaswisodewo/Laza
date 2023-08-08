//
//  ProductBrandViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 08/08/23.
//

import UIKit

class ProductBrandViewController: UIViewController {

    static let identifier = "ProductBrandViewController"
    
    @IBOutlet weak var brandLabel: UILabel!
    
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
            
        brandLabel.text = viewModel.brandName
        
        tabBarController?.tabBar.isHidden = true
    }
    
    func configure(brandName: String, products: [Product]) {
        viewModel = ProductBrandViewModel(brandName: brandName, products: products)
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

extension ProductBrandViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        vc.configure(product: product)
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
