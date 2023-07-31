//
//  HomeViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
    
    enum CollectionType: Int {
        case brand = 0
        case product = 1
    }
    
    static let identifier = "HomeViewController"
    
    @IBOutlet weak var menuButton: CircleButton! {
        didSet {
            menuButton.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var cartButton: CircleButton!
    
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var voiceButton: RoundedButton!
    
    @IBOutlet weak var viewAllBrandButton: UIButton!
    
    @IBOutlet weak var viewAllNewArrivalButton: UIButton!
    
    @IBOutlet weak var brandCollectionView: UICollectionView! {
        didSet {
            brandCollectionView.tag = CollectionType.brand.rawValue
            brandCollectionView.showsVerticalScrollIndicator = false
            brandCollectionView.showsHorizontalScrollIndicator = false
            brandCollectionView.delegate = self
            brandCollectionView.dataSource = self
            brandCollectionView.register(BrandCollectionViewCell.self, forCellWithReuseIdentifier: BrandCollectionViewCell.identifier)
        }
    }
    
    @IBOutlet weak var newArrivalCollectionView: UICollectionView! {
        didSet {
            newArrivalCollectionView.tag = CollectionType.product.rawValue
            newArrivalCollectionView.showsHorizontalScrollIndicator = false
            newArrivalCollectionView.delegate = self
            newArrivalCollectionView.dataSource = self
            newArrivalCollectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        }
    }
    
    private var sideMenuNavigationController: SideMenuNavigationController!
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarItemImage()
        setupSideMenuu()
        
        viewModel.reloadBrandCollectionView = { [weak self] in
            self?.brandCollectionView.reloadData()
        }
        viewModel.reloadProductCollectionView = { [weak self] in
            self?.newArrivalCollectionView.reloadData()
        }
        
        viewModel.loadBrands()
        viewModel.loadProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func setupSideMenuu() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: SideMenuViewController.identifier) as? SideMenuViewController else { return }
        vc.delegate = self
        
        sideMenuNavigationController = SideMenuNavigationController(rootViewController: vc)
        sideMenuNavigationController.leftSide = true
    }
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Home"
        label.font = UIFont(name: "Inter-Medium", size: 11)
        label.sizeToFit()
        
        navigationController?.tabBarItem.selectedImage = UIImage(view: label)
    }
    
    @objc private func menuButtonPressed() {
        present(sideMenuNavigationController, animated: true)
    }
    
    private func logoutButtonPressed() {
        viewModel.logout()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async { [weak self] in
            let vc = storyboard.instantiateViewController(withIdentifier: OnboardingViewController.identifier)
            let nav = UINavigationController(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: false)
            self?.view.window?.windowScene?.keyWindow?.rootViewController = nav
        }
    }
    
    private func updatePasswordButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        DispatchQueue.main.async { [weak self] in
            let vc = storyboard.instantiateViewController(withIdentifier: UpdatePasswordViewController.identifier)
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK: - UICollectionView Delegate & Data Source

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case CollectionType.brand.rawValue:
            return viewModel.brandsCount
        case CollectionType.product.rawValue:
            return viewModel.productsCount
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag {
        case CollectionType.brand.rawValue:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: BrandCollectionViewCell.identifier,
                for: indexPath) as? BrandCollectionViewCell else { return UICollectionViewCell() }
            let title = viewModel.getBrandOnIndex(index: indexPath.item)
            cell.setTitle(title: title)
            return cell
        case CollectionType.product.rawValue:
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ProductCollectionViewCell.identifier,
                for: indexPath) as? ProductCollectionViewCell else {
                print("failed to dequeue cell")
                return UICollectionViewCell()
            }
            if let model = viewModel.getProductOnIndex(index: indexPath.row) {
                cell.configure(product: model)
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag {
        case CollectionType.brand.rawValue:
            let padding: CGFloat = 10
            guard let item = viewModel.getBrandOnIndex(index: indexPath.item) else {
                return CGSize(width: 50, height: 50)
            }
            let itemWidth = item.size(withAttributes: [
                NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium)
            ]).width
            return CGSize(width: itemWidth + padding * 2, height: 50)
        case CollectionType.product.rawValue:
            let minimumInteritemSpacing: CGFloat = 16
            let numOfColum: CGFloat = 2.0
            let collectionViewFlowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            let spacing = (minimumInteritemSpacing * numOfColum) + collectionViewFlowLayout.sectionInset.left + collectionViewFlowLayout.sectionInset.right
            let width = (collectionView.frame.size.width / numOfColum ) - spacing
            let cellHeightToWidthAspectRatio = CGFloat(257.0 / 160)
            return CGSize(width: width, height: width * cellHeightToWidthAspectRatio)
        default:
            return CGSize(width: 200, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView.tag {
        case CollectionType.brand.rawValue:
            return 16
        case CollectionType.product.rawValue:
            return 16
        default:
            return 16
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView.tag {
        case CollectionType.brand.rawValue:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        case CollectionType.product.rawValue:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        default:
            return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
}

// MARK: - SideMenuViewController Delegate

extension HomeViewController: SideMenuViewControllerDelegate {
    
    func didSelectUpdatePassword() {
        updatePasswordButtonPressed()
        sideMenuNavigationController.dismiss(animated: true)
    }
    
    func didSelectLogOut() {
        sideMenuNavigationController.dismiss(animated: true)
        logoutButtonPressed()
    }
}
