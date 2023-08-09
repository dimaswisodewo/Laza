//
//  WalletViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

class WalletViewController: UIViewController {

    static let identifier = "WalletViewController"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.separatorStyle = .none
            tableView.register(WalletTableViewCell.self, forCellReuseIdentifier: WalletTableViewCell.identifier)
        }
    }
    
    private let viewModel = WalletViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarItemImage()
    }
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "My Cards"
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 12)
        label.sizeToFit()
        
        navigationController?.tabBarItem.selectedImage = UIImage(view: label)
    }
}

extension WalletViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WalletTableViewCell.identifier) as? WalletTableViewCell else {
            print("Failed to dequeue WalletTableViewCell")
            return UITableViewCell()
        }
        if let model = viewModel.getDataAtIndex(indexPath.row) {
            // Wait 0.1 sec before set the CreditCardFormView, otherwise the CreditCardFormView will not be layouted properly
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                print("Configure: ", model)
                cell.configure(model: model)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let inset: CGFloat = 20
        let heightToWidthRatio = PaymentCardCollectionViewCell.heigthToWidthRatio
        let width: CGFloat = tableView.bounds.width - (CGFloat(2) * inset)
        let height: CGFloat = width * heightToWidthRatio
        return height
    }
}
