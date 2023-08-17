//
//  ListAddressViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 09/08/23.
//

import UIKit

class ListAddressViewController: UIViewController {
    
    static let identifier = "ListAddressViewController"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(ListAddressItemTableViewCell.nib, forCellReuseIdentifier: ListAddressItemTableViewCell.identifier)
        }
    }
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var ctaButton: UIButton! {
        didSet {
            ctaButton.addTarget(self, action: #selector(ctaButtonPressed), for: .touchUpInside)
        }
    }
    
    var onDismiss: (() -> Void)?
    
    private let viewModel = ListAddressViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
    }
    
    func configure(address: [Address]) {
        viewModel.configure(address: address)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
        onDismiss?()
    }
    
    @objc private func ctaButtonPressed() {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: AddressViewController.identifier) as? AddressViewController else {
            return
        }
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate

extension ListAddressViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.addressCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListAddressItemTableViewCell.identifier) as? ListAddressItemTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(model: viewModel.getAddressAtIndex(index: indexPath.row))
        return cell
    }
}

// MARK: - AddressViewControllerDelegate

extension ListAddressViewController: AddressViewControllerDelegate {
    
    func onNewAddressAdded(newAddress: AddAddress) {
        let address = Address(
            id: newAddress.id,
            country: newAddress.country,
            city: newAddress.city,
            receiverName: newAddress.receiverName,
            phoneNumber: newAddress.phoneNumber)
        viewModel.addNewAddress(newAddress: address)
        SnackBarSuccess.make(in: self.view, message: "Added new address", duration: .lengthShort).show()
        self.tableView.reloadData()
    }
}
