//
//  CartViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit
import SkeletonView

class CartViewController: UIViewController {
    
    static let identifier = "CartViewController"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.contentInset = .init(top: 0, left: 20, bottom: 0, right: -20)
            tableView.separatorStyle = .none
            tableView.register(CartTableViewCell.nib, forCellReuseIdentifier: CartTableViewCell.identifier)
        }
    }
    
    @IBOutlet weak var cartDetailButton: UIButton! {
        didSet {
            cartDetailButton.addTarget(self, action: #selector(cartDetailButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var checkoutButton: UIButton! {
        didSet {
            checkoutButton.addTarget(self, action: #selector(checkoutButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var totalPriceLabel: UILabel! {
        didSet {
            totalPriceLabel.text = "$0"
        }
    }
    
    private let viewModel = CartViewModel()
    
    private var timer: Timer? = Timer()
    private let timerMax: TimeInterval = 0.7
    private var currentTimer: TimeInterval = 0.7
    private var isApiCallAllowed = true
    
    private var selectedAddress: Address?
    private var selectedPayment: CreditCardModel?
    
    deinit {
        timer?.invalidate()
        timer = nil
        
        removeObserver()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarItemImage()
        setupRefreshControl()
        setupSkeleton()
        showSkeleton()
        
        loadAllSizesAndCartItems()
        
        registerObserver()
    }
    
    private func setupSkeleton() {
        tableView.isSkeletonable = true
    }
    
    private func showSkeleton() {
        tableView.showAnimatedGradientSkeleton()
    }
    
    private func hideSkeleton() {
        tableView.hideSkeleton()
    }
    
    private func registerObserver() {
        print("Register cart updated")
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifyLoadCartItems), name: Notification.Name.cartUpdated, object: nil)
    }
    
    private func removeObserver() {
        print("Remove cart updated")
        NotificationCenter.default.removeObserver(self, name: Notification.Name.cartUpdated, object: nil)
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        loadCartItems(onFinished: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                self?.tableView.refreshControl?.endRefreshing()
            }
        })
    }
    
    // Add delay to API call to avoid spamming on (+) and (-) buttons in cart page
    private func activateApiCallDelay() {
        isApiCallAllowed = false
        timer?.invalidate()
        currentTimer = timerMax
        timer = Timer.scheduledTimer(withTimeInterval: timerMax, repeats: false, block: { [weak self] _ in
            // Timer done
            self?.isApiCallAllowed = true
            self?.timer?.invalidate()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {

        tabBarController?.tabBar.isHidden = false
    }
    
    private func loadAllSizesAndCartItems() {
        viewModel.getAllSize(completion: { [weak self] in
            self?.loadCartItems()
        }, onError: { [weak self] errorMessage in
            guard let self = self else { return }
            SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
        })
    }
    
    @objc private func onNotifyLoadCartItems() {
        loadCartItems()
    }
    
    private func loadCartItems(onFinished: (() -> Void)? = nil) {
        viewModel.getCartItems(completion: {
            DispatchQueue.main.async { [weak self] in
                self?.hideSkeleton()
                self?.tableView.reloadData()
                guard let totalPrice = self?.viewModel.cart?.orderInfo.total else {
                    return
                }
                self?.setTotalPriceLabel(totalPrice: totalPrice)
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
    
    private func loadOrderInfo() {
        viewModel.getOrderInfo(completion: {
            DispatchQueue.main.async { [weak self] in
                guard let totalPrice = self?.viewModel.cart?.orderInfo.total else {
                    return
                }
                self?.setTotalPriceLabel(totalPrice: totalPrice)
            }
        }, onError: { errorMessage in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
            }
        })
    }
    
    private func setTotalPriceLabel(totalPrice: Int) {
        totalPriceLabel.text = "$\(totalPrice)".formatDecimal()
    }
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Order"
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 12)
        label.sizeToFit()
        
        navigationController?.tabBarItem.selectedImage = UIImage(view: label)
    }
    
    @objc private func cartDetailButtonPressed() {
        presentCartDetail()
    }
    
    @objc private func checkoutButtonPressed() {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: OrderConfirmedViewController.identifier) as? OrderConfirmedViewController else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func presentCartDetail() {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: CartDetailViewController.identifier) as? CartDetailViewController else { return }
        if let orderInfo = viewModel.cart?.orderInfo {
            vc.configure(address: selectedAddress, payment: selectedPayment, orderInfo: orderInfo)
        }
        vc.delegate = self
        vc.setSelectedAddress = { [weak self] newAddress in
            self?.selectedAddress = newAddress
        }
        vc.setSelectedPayment = { [weak self] creditCard in
            self?.selectedPayment = creditCard
        }
        present(vc, animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cart?.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier) as? CartTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.setIndexPath(indexPath: indexPath)
        if let model = viewModel.getCartItemAtIndex(index: indexPath.item),
           let sizeId = viewModel.getSizeId(size: model.size) {
            cell.hideSkeleton()
            cell.configure(model: model, sizeId: sizeId)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: - CartDetailViewController Delegate

extension CartViewController: CartDetailViewControllerDelegate {
    
    func addressButtonPressed(loadedAddress: [Address]) {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: ListAddressViewController.identifier) as? ListAddressViewController else {
            print("Failed to get VC")
            return
        }
        vc.delegate = self
        vc.configure(address: loadedAddress)
        // Present CartDetailViewController again
        vc.onDismiss = presentCartDetail
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func cardButtonPressed() {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: ChoosePaymentViewController.identifier) as? ChoosePaymentViewController else {
            print("Failed to get VC")
            return
        }
        // Present CartDetailViewController again
        vc.onDismiss = presentCartDetail
        // Select credit card
        vc.onSelectCreditCard = { [weak self] selectedCard in
            self?.selectedPayment = selectedCard
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - CartTableViewCellDelegate

extension CartViewController: CartTableViewCellDelegate {
    
    func deleteCartItems(productId: Int, sizeId: Int, indexPath: IndexPath) {
        if !isApiCallAllowed { return }
        activateApiCallDelay()
        
        viewModel.deleteCartItems(productId: productId, sizeId: sizeId, completion: { [weak self] in
            // Delete cart items
            self?.viewModel.deleteCartItemsAtIndex(index: indexPath.row)
            DispatchQueue.main.async {
                self?.tableView.deleteRows(at: [indexPath], with: .left)
            }
            // Update cart items
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self?.loadCartItems() // Update cart items
            }
            self?.loadOrderInfo()
        }, onError: { errorMessage in
            print(errorMessage)
        })
    }
    
    func updateCartItems(productId: Int, sizeId: Int, indexPath: IndexPath, completion: @escaping (AddToCart) -> Void) {
        if !isApiCallAllowed { return }
        activateApiCallDelay()
        
        viewModel.updateCartItems(productId: productId, sizeId: sizeId, completion: { [weak self] addToCart in
            guard let unwrappedData = addToCart else {
                // When passed data is nil, it means quantity reach 0, thus delete the product from carts
                // Delete cart items
                self?.viewModel.deleteCartItemsAtIndex(index: indexPath.row)
                DispatchQueue.main.async {
                    self?.tableView.deleteRows(at: [indexPath], with: .left)
                }
                // Update cart items
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.loadCartItems() // Update cart items
                }
                return
            }
            completion(unwrappedData)
            self?.loadOrderInfo()
        }, onError: { errorMessage in
            print(errorMessage)
        })
    }
    
    func insertToCart(productId: Int, sizeId: Int, completion: @escaping (AddToCart) -> Void) {
        if !isApiCallAllowed { return }
        activateApiCallDelay()
        
        viewModel.insertToCart(productId: productId, sizeId: sizeId, completion: { [weak self] addToCart in
            completion(addToCart)
            self?.loadOrderInfo()
        }, onError: { errorMessage in
            print(errorMessage)
        })
    }
}

// MARK: - ListAddressViewControllerDelegate

extension CartViewController: ListAddressViewControllerDelegate {
    
    func didDeleteAddress() {
        selectedAddress = nil
    }
    
    func didSelectAddress(model: Address) {
        selectedAddress = model
        presentCartDetail()
    }
    
    func didUpdateAddress(model: Address) {
        selectedAddress = model
    }
}

// MARK: - SkeletonTableViewDataSource

extension CartViewController: SkeletonTableViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return CartTableViewCell.identifier
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, skeletonCellForRowAt indexPath: IndexPath) -> UITableViewCell? {
        guard let cell = skeletonView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier) as? CartTableViewCell else {
            return UITableViewCell()
        }
        cell.showSkeleton()
        return cell
    }
}
