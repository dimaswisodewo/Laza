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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
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
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ListAddressViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListAddressItemTableViewCell.identifier) as? ListAddressItemTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
}
