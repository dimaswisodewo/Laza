//
//  ChoosePaymentViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 10/08/23.
//

import UIKit

enum PaymentType {
    case Gopay
    case CreditCard
}

class ChoosePaymentViewController: UIViewController {
    
    static let identifier = "ChoosePaymentViewController"
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var proceedButton: UIButton! {
        didSet {
            proceedButton.addTarget(self, action: #selector(proceedButtonPressed), for: .touchUpInside)
            setEnableProceedButton(isEnable: false)
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(ChoosePaymentTableViewCell.nib, forCellReuseIdentifier: ChoosePaymentTableViewCell.identifier)
        }
    }
    
    private let viewModel = ChoosePaymentViewModel()
    
    var onSelectCreditCard: ((CreditCardModel) -> Void)?
    var onDismiss: (() -> Void)?
    
    private var deactivateAllCheckmarks = [() -> Void]()
    private var selectedRow: ChoosePaymentTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
    }

    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
        onDismiss?()
    }
    
    @objc private func proceedButtonPressed() {
        if selectedRow?.paymentTitle == "credit-card" {
            let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: PaymentViewController.identifier) as? PaymentViewController else { return }
            vc.onSelectCreditCard = onSelectCreditCard // Select credit card
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func setEnableProceedButton(isEnable: Bool) {
        proceedButton.isEnabled = isEnable
        proceedButton.backgroundColor = isEnable ? ColorUtils.shared.getColor(color: .PurpleButton) : ColorUtils.shared.getColor(color: .TextSecondary)
    }
}

extension ChoosePaymentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChoosePaymentTableViewCell.identifier) as? ChoosePaymentTableViewCell else {
            return UITableViewCell()
        }
        if let model = viewModel.getDataAtIndex(index: indexPath.row) {
            cell.configure(
                paymentTitle: model.name,
                paymentImage: UIImage(named: model.imageName))
        }
        if !cell.isSubscribedDeactivateCheckmark {
            cell.isSubscribedDeactivateCheckmark = true
            deactivateAllCheckmarks.append({ [weak self] in
                guard let selectedRow = self?.selectedRow else { return }
                if cell == selectedRow { return }
                cell.setCheckmarkImage(isActive: false)
            })
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ChoosePaymentTableViewCell else { return }
        cell.toggleCheckmarkImage()
        
        if cell == selectedRow, !cell.isCheckmarkActive {
            selectedRow = nil
            setEnableProceedButton(isEnable: false)
        } else {
            selectedRow = cell // Cache selected cell, to exclude the cell when deactivating all checkmark
            // Deactivate all checkmarks
            deactivateAllCheckmarks.forEach { deactivateCheckmark in
                deactivateCheckmark()
            }
            setEnableProceedButton(isEnable: true)
        }
    }
}
