//
//  ListAddressViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 09/08/23.
//

import UIKit

protocol ListAddressViewControllerDelegate: AnyObject {
    
    func didSelectAddress(model: Address)
    
    func didUpdateAddress(model: Address)
    
    func didDeleteAddress()
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
        
        registerObserver()
        setupRefreshControl()
        
        if viewModel.addressCount == 0 {
            loadAllAddress()
        }
    }
    
    deinit {
        removeObserver()
    }
    
    private func registerObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(onNotifyLoadAllAddress), name: .addressUpdated, object: nil)
    }
    
    private func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: .addressUpdated, object: nil)
    }
    
    private func notifyObserver() {
        NotificationCenter.default.post(name: .addressUpdated, object: nil)
    }
    
    private func setupRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc private func handleRefreshControl() {
        loadAllAddress(onFinished: {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.refreshControl?.endRefreshing()
            }
        })
        
    }
    
    func configure(address: [Address]) {
        viewModel.configure(address: address)
        print("Address count: \(address.count)")
    }
    
    private func loadAllAddress(onFinished: (() -> Void)? = nil) {
        viewModel.getAllAddress(completion: { [weak self] in
            guard let self = self else { return }
            // Get primary address
            for address in self.viewModel.address {
                if let isPrimary = address.isPrimary, isPrimary {
                    self.delegate?.didUpdateAddress(model: address)
                    break
                }
            }
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
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
    
    @objc private func onNotifyLoadAllAddress() {
        loadAllAddress()
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
           
           // Font metrics used to set font of UILabel
           let fontMetrics = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14),
            maximumPointSize: 14)
           
           // Change Name Action
           let edit = UIContextualAction(style: .normal, title: nil) { [weak self] action, view, completion in
               self?.handleEditSwipeAction(indexPath: indexPath)
               completion(true)
           }
           
           /// Since we cannot change the font on `UIContextualAction`, we can just convert
           /// a `UILabel` into an image, then set it into the `UIContextualAction`
           let namelabel = UILabel()
           namelabel.numberOfLines = 2
           namelabel.textAlignment = .center
           namelabel.text = "Edit"
           namelabel.textColor = .white
           namelabel.font = fontMetrics
           namelabel.sizeToFit()
           edit.image = UIImage(view: namelabel)
           edit.backgroundColor = .systemBlue
           
           // Delete Action
           let delete = UIContextualAction(style: .destructive, title: nil) { [weak self] action, view, completion in
               self?.handleDeleteSwipeAction(indexPath: indexPath)
               completion(true)
           }
           
           /// Since we cannot change the font on `UIContextualAction`, we can just convert
           /// a `UILabel` into an image, then set it into the `UIContextualAction`
           let deleteLabel = UILabel()
           deleteLabel.text = "Delete"
           deleteLabel.textColor = .white
           deleteLabel.font = fontMetrics
           deleteLabel.sizeToFit()
           delete.image = UIImage(view: deleteLabel)
           delete.backgroundColor = .systemRed
           
           let configuration = UISwipeActionsConfiguration(actions: [delete, edit])
           configuration.performsFirstActionWithFullSwipe = false
           return configuration
       }
       
       private func handleEditSwipeAction(indexPath: IndexPath) {
           guard let address = viewModel.getAddressAtIndex(index: indexPath.row) else { return }
           let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
           guard let vc = storyboard.instantiateViewController(withIdentifier: EditAddressViewController.identifier) as? EditAddressViewController else { return }
           vc.configure(address: address)
           navigationController?.pushViewController(vc, animated: true)
       }
       
       private func handleDeleteSwipeAction(indexPath: IndexPath) {
           guard let addressId = viewModel.getAddressAtIndex(index: indexPath.row)?.id else { return }
           viewModel.deleteAddress(
            addressId: addressId,
            completion: {
                DispatchQueue.main.async { [weak self] in
                    self?.delegate?.didDeleteAddress()
                    self?.viewModel.deleteAddressAtIndex(index: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .left)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                    self?.notifyObserver()
                }
            },
            onError: { errorMessage in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
                }
            })
       }
}

// MARK: - AddressViewControllerDelegate

extension ListAddressViewController: AddressViewControllerDelegate {
    
    func onNewAddressAdded(newAddress: Address) {
        SnackBarSuccess.make(in: self.view, message: "Address updated", duration: .lengthShort).show()
        // Set primary address
        if let isPrimary = newAddress.isPrimary, isPrimary {
            self.delegate?.didUpdateAddress(model: newAddress)
        }
        self.tableView.reloadData()
    }
}
