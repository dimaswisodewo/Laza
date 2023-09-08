//
//  HomeViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController, UINavigationControllerDelegate {
    
    enum CollectionType: Int {
        case brand = 0
        case product = 1
    }
    
    static let identifier = "HomeViewController"
    
    @IBOutlet weak var menuButton: CircleButton! {
        didSet {
            menuButton.addTarget(self, action: #selector(menuButtonPressed), for: .touchUpInside)
            // Set image size in button manually
            let imageWidth = 25
            let size = CGSize(width: imageWidth, height: imageWidth)
            let rect = CGRect(origin: .zero, size: size)
            var image = UIImage(named: "Menu")
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0) // Creates a bitmap-based graphics context with the specified options
            image?.draw(in: rect) // This method draws the entire image in the current graphics context
            image = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(.alwaysTemplate)
            menuButton.setImage(image, for: .normal)
            menuButton.tintColor = ColorUtils.shared.getColor(color: .TextPrimary)
        }
    }
    
    @IBOutlet weak var cartButton: CircleButton! {
        didSet {
            let image = cartButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            cartButton.setImage(image, for: .normal)
            cartButton.tintColor = ColorUtils.shared.getColor(color: .TextPrimary)
        }
    }
    
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.searchTextField.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14)
        }
    }
    
    @IBOutlet weak var tableView: IntrinsicTableView! {
        didSet {
            tableView.backgroundColor = ColorUtils.shared.getColor(color: .WhiteBG)
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
            tableView.separatorStyle = .none
        }
    }
    
    private var brandTableViewCell: BrandTableViewCell?
    private var productTableViewCell: ProductTableViewCell?
    
    private let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.alpha = 0
        view.isHidden = true
        return view
    }()
    
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
        setupSideMenu()
        setupBlur()
        setupRefreshControl()
        
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
        
        registerObserver()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.brandTableViewCell?.collectionView.reloadData()
            self?.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    // Remove observer to reload reviews
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.profileUpdated, object: nil)
    }
    
    // Register observer to reload reviews when there are new review added
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onProfileUpdated), name: Notification.Name.profileUpdated, object: nil)
    }
    
    @objc private func onProfileUpdated() {
        setupSideMenu()
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        
        var brandsDone = false
        var productsDone = false
        
        // Load data
        viewModel.loadBrands(onFinished: {
            brandsDone = true
            endRefreshingWhenDone()
        })
        viewModel.loadProducts(onFinished: {
            productsDone = true
            endRefreshingWhenDone()
        })
        
        func endRefreshingWhenDone() {
            if !brandsDone || !productsDone { return }
            // Dismiss the refresh control
            DispatchQueue.main.async { [weak self] in
                self?.tableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    // End editing on touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func registerTableViewCell() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BrandTableViewCell.self, forCellReuseIdentifier: BrandTableViewCell.identifier)
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
    }
    
    private func setupBlur() {
        guard let superView = tabBarController?.view else { return }
        superView.addSubview(blurView)
        blurView.frame = superView.bounds
        
        let blurEffect = UIBlurEffect(style: .regular)
        let vfxView = UIVisualEffectView(effect: blurEffect)
        blurView.addSubview(vfxView)
        vfxView.frame = blurView.bounds
    }
    
    private func hideBlurView(isHidden: Bool) {
        blurView.isHidden = false
        UIView.animate(withDuration: 0.2, delay: 0, animations: { [weak self] in
            self?.blurView.alpha = isHidden ? 0 : 1
        }, completion: { [weak self] _ in
            self?.blurView.isHidden = isHidden
        })
    }
    
    private func setupSideMenu() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: SideMenuViewController.identifier) as? SideMenuViewController else { return }
        vc.delegate = self
        if let profile = DataPersistentManager.shared.getProfileFromKeychain() {
            vc.configure(profile: profile)
        }
        sideMenuNavigationController = SideMenuNavigationController(rootViewController: vc)
        sideMenuNavigationController.delegate = self
        sideMenuNavigationController.menuWidth = view.bounds.width * 0.8
        sideMenuNavigationController.leftSide = true
        sideMenuNavigationController.presentationStyle = .menuSlideIn
        sideMenuNavigationController.navigationBar.isHidden = true
    }
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Home"
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 12)
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
            let vc = storyboard.instantiateViewController(withIdentifier: LoginViewController.identifier)
            let nav = UINavigationController(rootViewController: vc)
            nav.setNavigationBarHidden(true, animated: false)
            self?.view.window?.windowScene?.keyWindow?.rootViewController = nav
        }
    }
    
    private func updatePasswordButtonPressed() {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        DispatchQueue.main.async { [weak self] in
            guard let vc = storyboard.instantiateViewController(withIdentifier: ChangePasswordViewController.identifier) as? ChangePasswordViewController else { return }
            vc.delegate = self
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setupSelectedViewControllerInTabBar(selectedIndex: Int, identifier: String) {
        self.tabBarController?.selectedIndex = selectedIndex
        sideMenuNavigationController.dismiss(animated: true)
    }
}

// MARK: - SideMenuNavigationController Delegate

extension HomeViewController: SideMenuNavigationControllerDelegate {
    
    func sideMenuWillAppear(menu: SideMenuNavigationController, animated: Bool) {
        hideBlurView(isHidden: false)
    }
    
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        hideBlurView(isHidden: true)
    }
}

// MARK: - SideMenuViewController Delegate

extension HomeViewController: SideMenuViewControllerDelegate {
    
    func didSelectProfile() {
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        guard let vc = storyboard.instantiateViewController(withIdentifier: ProfileViewController.identifier) as? ProfileViewController else { return }
//        guard let profile = SessionManager.shared.currentProfile else { return }
//        vc.configure(model: profile)
//        sideMenuNavigationController.dismiss(animated: true) { [weak self] in
//            self?.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    func didSelectDarkMode() {
        
    }
    
    func didSelectCards() {
        setupSelectedViewControllerInTabBar(selectedIndex: 3, identifier: WalletViewController.identifier)
    }
    
    func didSelectWishlist() {
        setupSelectedViewControllerInTabBar(selectedIndex: 1, identifier: WishlistViewController.identifier)
    }
    
    func didSelectOrders() {
        setupSelectedViewControllerInTabBar(selectedIndex: 2, identifier: CartViewController.identifier)
    }
    
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            print("Failed get header")
            return
        }

        var contentConfig = header.defaultContentConfiguration()
        contentConfig.directionalLayoutMargins = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
        contentConfig.textProperties.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 18)
        contentConfig.textProperties.color = ColorUtils.shared.getColor(color: .TextPrimary) ?? .label
        contentConfig.textProperties.transform = .capitalized
        contentConfig.text = sections[section]

        header.contentConfiguration = contentConfig
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case CollectionType.brand.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BrandTableViewCell.identifier) as? BrandTableViewCell else {
                print("Get BrandTableViewCell failed")
                return UITableViewCell()
            }
            cell.delegate = self
            cell.hideSkeleton()
            // Cache table view cell to get the collection view for reload data
            if brandTableViewCell == nil {
                brandTableViewCell = cell
            }
            return cell
        case CollectionType.product.rawValue:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier) as? ProductTableViewCell else {
                print("Get ProductTableViewCell failed")
                return UITableViewCell()
            }
            cell.delegate = self
            cell.hideSkeleton()
            // Cache table view cell to get the collection view for reload data
            if productTableViewCell == nil {
                productTableViewCell = cell
            }
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
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
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
            NSAttributedString.Key.font : FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 17)
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
        collectionViewCell.delegate = self
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
    
    func productDidSelectItemAt(didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: DetailViewController.identifier) as? DetailViewController else { return }
        guard let product = viewModel.getProductOnIndex(index: indexPath.item) else { return }
        vc.configure(productId: product.id)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - BrandCollectionViewCell Delegate

extension HomeViewController: BrandCollectionViewCellDelegate {
    
    func brandButtonPressed(brandName: String) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: ProductBrandViewController.identifier) as? ProductBrandViewController else { return }
        vc.configure(brandName: brandName)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - ChangePasswordViewController Delegate

extension HomeViewController: ChangePasswordViewControllerDelegate {
    
    func onPasswordUpdated() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            SnackBarSuccess.make(in: self.view, message: "Password updated", duration: .lengthShort).show()
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchBar.text else { return }
        print(text)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterProducts(keyword: searchText)
        productTableViewCell?.collectionView.reloadData()
        tableView.reloadData()
    }
}
