//
//  CartViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarItemImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        tabBarController?.tabBar.isHidden = false
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
    
    private func presentCartDetail() {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: CartDetailViewController.identifier) as? CartDetailViewController else { return }
        
        vc.delegate = self
        present(vc, animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate

extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartTableViewCell.identifier) as? CartTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
}

// MARK: - CartDetailViewController Delegate

extension CartViewController: CartDetailViewControllerDelegate {
    
    func addressButtonPressed() {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: AddressViewController.identifier) as? AddressViewController else {
            print("Failed to get VC")
            return
        }
        // Present CartDetailViewController again
        vc.onDismiss = presentCartDetail
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func cardButtonPressed() {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: AddCardViewController.identifier) as? AddCardViewController else {
            print("Failed to get VC")
            return
        }
        // Present CartDetailViewController again
        vc.onDismiss = presentCartDetail
        navigationController?.pushViewController(vc, animated: true)
    }
}
