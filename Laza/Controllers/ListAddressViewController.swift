//
//  ListAddressViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 09/08/23.
//

import UIKit

protocol ListAddressViewControllerDelegate: AnyObject {
    
    func didSelectAddress(model: Address)
}

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
    
    weak var delegate: ListAddressViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
        
        if viewModel.addressCount == 0 {
            loadAllAddress()
        }
    }
    
    func configure(address: [Address]) {
        viewModel.configure(address: address)
        print("Address count: \(address.count)")
    }
    
    private func loadAllAddress() {
        viewModel.getAllAddress(completion: {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }, onError: { errorMessage in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
            }
        })
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
        if let model = viewModel.getAddressAtIndex(index: indexPath.row) {
            cell.configure(model: model)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let address = viewModel.getAddressAtIndex(index: indexPath.row) else { return }
        navigationController?.popViewController(animated: true)
        delegate?.didSelectAddress(model: address)
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
