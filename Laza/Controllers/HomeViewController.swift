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
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
            tableView.separatorStyle = .none
            tableView.bounces = false
        }
    }
    
    private var brandTableViewCell: BrandTableViewCell?
    private var productTableViewCell: ProductTableViewCell?
    
    let sections = [
        "Brands",
        "Products"
    ]
    
    private var sideMenuNavigationController: SideMenuNavigationController!
    
    private let viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerTableViewCell()
        
        setupTabBarItemImage()
        setupSideMenuu()
        
        // Assign reload collection view functionality
        viewModel.reloadBrandCollectionView = { [weak self] in
            self?.brandTableViewCell?.collectionView.reloadData()
            self?.tableView.reloadData()
            print("Reload brand collection view")
        }
        viewModel.reloadProductCollectionView = { [weak self] in
            self?.productTableViewCell?.collectionView.reloadData()
            self?.tableView.reloadData()
            print("Reload product collection view")
        }
        
        // Load data
        viewModel.loadBrands()
        viewModel.loadProducts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    private func registerTableViewCell() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BrandTableViewCell.self, forCellReuseIdentifier: BrandTableViewCell.identifier)
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
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

// MARK: - UITableView Delegate & DataSource

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case CollectionType.brand.rawValue:
            return 1
        case CollectionType.product.rawValue:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section]
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        60
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case CollectionType.brand.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BrandTableViewCell.identifier) as? BrandTableViewCell else {
                print("Get BrandTableViewCell failed")
                return UITableViewCell()
            }
            cell.delegate = self
            // Cache table view for reload data
            brandTableViewCell = cell
            return cell
        case CollectionType.product.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier) as? ProductTableViewCell else {
                print("Get ProductTableViewCell failed")
                return UITableViewCell()
            }
            cell.delegate = self
            // Cache table view for reload data
            productTableViewCell = cell
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case CollectionType.brand.rawValue:
            return 50
        case CollectionType.product.rawValue:
            return 300
        default:
            return 50
        }
    }
}

// MARK: - BrandTableViewCell Delegate

extension HomeViewController: BrandTableViewCellDelegate {
    
    func brandSizeForItemAt(sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 10
        guard let item = viewModel.getBrandOnIndex(index: indexPath.item) else {
            return CGSize(width: 50, height: 50)
        }
        let itemWidth = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont(name: "Inter-Medium", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .medium)
        ]).width
        return CGSize(width: itemWidth + padding * 2, height: 50)
    }
    
    func brandNumberOfItemsInSection(numberOfItemsInSection section: Int) -> Int {
        viewModel.brandsCount
    }
    
    func brandCellForItemAt(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue BrandTableViewCell
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: BrandTableViewCell.identifier) as? BrandTableViewCell else {
            return UICollectionViewCell()
        }
        // Dequeue BrandCollectionViewCell
        guard let collectionViewCell = tableViewCell.collectionView.dequeueReusableCell(withReuseIdentifier: BrandCollectionViewCell.identifier, for: indexPath) as? BrandCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let title = viewModel.getBrandOnIndex(index: indexPath.item) else {
            print("Failed to get brand on index")
            return UICollectionViewCell()
        }
        collectionViewCell.setTitle(title: title)
        return collectionViewCell
    }
}

// MARK: - ProductTableViewCell Delegate

extension HomeViewController: ProductTableViewCellDelegate {
    
    func productNumberOfItemsInSection(numberOfItemsInSection section: Int) -> Int {
        viewModel.productsCount
    }
    
    func productCellForItemAt(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Dequeue BrandTableViewCell
        guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier) as? ProductTableViewCell else {
            print("Failed to get product table view cell")
            return UICollectionViewCell()
        }
        // Dequeue BrandCollectionViewCell
        guard let collectionViewCell = tableViewCell.collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            print("Failed to get product collection view cell")
            return UICollectionViewCell()
        }
        guard let product = viewModel.getProductOnIndex(index: indexPath.item) else {
            print("Failed to get product on index")
            return UICollectionViewCell()
        }
        collectionViewCell.configure(product: product)
        return collectionViewCell
    }
}
