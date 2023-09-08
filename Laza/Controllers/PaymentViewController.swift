//
//  PaymentViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 08/08/23.
//

import UIKit

class PaymentViewController: UIViewController {
    
    enum Rows: Int, CaseIterable {
        case Card = 0
        case AddCard = 1
        case Form = 2
    }
    
    static let identifier = "PaymentViewController"
    
    @IBOutlet weak var backButton: CircleButton! {
        didSet {
            backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var plusButton: CircleButton! {
        didSet {
            plusButton.addTarget(self, action: #selector(plusButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var ctaButton: UIButton! {
        didSet {
            ctaButton.addTarget(self, action: #selector(ctaButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var tableView: IntrinsicTableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.backgroundColor = ColorUtils.shared.getColor(color: .WhiteBG)
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.register(PaymentCardTableViewCell.nib, forCellReuseIdentifier: PaymentCardTableViewCell.identifier)
            tableView.register(PaymentAddCardTableViewCell.nib, forCellReuseIdentifier: PaymentAddCardTableViewCell.identifier)
            tableView.register(PaymentFormTableViewCell.nib, forCellReuseIdentifier: PaymentFormTableViewCell.identifier)
        }
    }
    
    private weak var paymentCardTableViewCell: PaymentCardTableViewCell?
    private weak var paymentAddCardTableViewCell: PaymentAddCardTableViewCell?
    private weak var paymentFormTableViewCell: PaymentFormTableViewCell?
        
    private let viewModel: PaymentViewModel = PaymentViewModel()
    
    var onSelectCreditCard: ((CreditCardModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        getCreditCards()
        
        // Reload table view, wait 0.1 sec to make sure that collection views inside the table view is finished layouting subviews
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.paymentCardTableViewCell?.collectionView.reloadData()
            self?.tableView.reloadData()
        }
    }
    
    // End editing on touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func getCreditCards() {
        viewModel.getCreditCards(
            completion: {
                DispatchQueue.main.async { [weak self] in
                    self?.paymentCardTableViewCell?.collectionView.reloadData()
                    self?.tableView.reloadData()
                }
            },
            onError: { errorMessage in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
                }
            })
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func plusButtonPressed() {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: AddCardViewController.identifier) as? AddCardViewController else { return }
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func ctaButtonPressed() {
        guard let selectedIndex = paymentCardTableViewCell?.selectedViewIndex else { return }
        let selectedCard = viewModel.getDataAtIndex(selectedIndex)
        onSelectCreditCard?(selectedCard)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableView DataSource & Delegate

extension PaymentViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // There is no card added
        if viewModel.dataCount == 0 { return 0 }
        // At least one card added
        return Rows.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case Rows.Card.rawValue:
            let heightToWidthRatio = PaymentCardCollectionViewCell.heigthToWidthRatio
            let width: CGFloat = tableView.bounds.width
            let height: CGFloat = width * heightToWidthRatio
            return height
        case Rows.AddCard.rawValue:
            return 80
        case Rows.Form.rawValue:
            return UITableView.automaticDimension
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case Rows.Card.rawValue:
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: PaymentCardTableViewCell.identifier) as? PaymentCardTableViewCell else {
                print("Failed to dequeue PaymentCardTableViewCell")
                return UITableViewCell()
            }
            tableViewCell.delegate = self
            tableViewCell.setNumberOfSavedCards(viewModel.dataCount)
            paymentCardTableViewCell = tableViewCell
            return tableViewCell
        case Rows.AddCard.rawValue:
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: PaymentAddCardTableViewCell.identifier) as? PaymentAddCardTableViewCell else {
                print("Failed to dequeue PaymentAddCardTableViewCell")
                return UITableViewCell()
            }
            tableViewCell.delegate = self
            paymentAddCardTableViewCell = tableViewCell
            return tableViewCell
        case Rows.Form.rawValue:
            guard let tableViewCell = tableView.dequeueReusableCell(withIdentifier: PaymentFormTableViewCell.identifier) as? PaymentFormTableViewCell else {
                print("Failed to dequeue PaymentFormTableViewCell")
                return UITableViewCell()
            }
            paymentFormTableViewCell = tableViewCell
            paymentFormTableViewCell?.setEnableFields(isEnable: false)
            // Set first item
            if viewModel.dataCount > 0 {
                let model = viewModel.getDataAtIndex(0)
                paymentFormTableViewCell?.setPredefinedValue(
                    cardOwner: model.owner,
                    cardNumber: model.cardNumber,
                    exp: "\(model.expMonth)/\(model.expYear)",
                    cvv: model.cvc ?? " - ")
            }
            return tableViewCell
        default:
            return UITableViewCell()
        }
    }
}

// MARK: - PaymentCardTableViewCellDelegate

extension PaymentViewController: PaymentCardTableViewCellDelegate {
    
    func onSetSelectedCardOnSwipe(selectedIndex: Int) {
        let model = viewModel.getDataAtIndex(selectedIndex)
        paymentFormTableViewCell?.setPredefinedValue(
            cardOwner: model.owner,
            cardNumber: model.cardNumber,
            exp: "\(model.expMonth)/\(model.expYear)",
            cvv: model.cvc ?? " - ")
    }
    
    func collectionView(collectionView: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let inset: CGFloat = 20
        let heightToWidthRatio = PaymentCardCollectionViewCell.heigthToWidthRatio
        let width: CGFloat = collectionView.bounds.width - (CGFloat(2) * inset)
        let height: CGFloat = width * heightToWidthRatio
        return CGSize(width: width, height: height)
    }
    
    func collectionView(numberOfItemsInSection section: Int) -> Int {
        return viewModel.dataCount
    }
    
    func collectionView(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = paymentCardTableViewCell?.collectionView.dequeueReusableCell(withReuseIdentifier: PaymentCardCollectionViewCell.identifier, for: indexPath) as? PaymentCardCollectionViewCell else {
            print("Failed to dequeue PaymentCardCollectionViewCell")
            return UICollectionViewCell()
        }
        let model = viewModel.getDataAtIndex(indexPath.item)
        // Wait for 0.1 sec, otherwise the CreditCardFormView will not be layouted properly
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            cell.configure(model: model)
        }
        return cell
    }
}

// MARK: - PaymentAddCardTableViewCellDelegate

extension PaymentViewController: PaymentAddCardTableViewCellDelegate {
    
    func deleteCardButtonPressed() {
        paymentAddCardTableViewCell?.setEnableButtons(isEnable: false)
        guard let selectedCardIndex = paymentCardTableViewCell?.selectedViewIndex else { return }
        let selectedCardModel = viewModel.getDataAtIndex(selectedCardIndex)
        viewModel.deleteCreditCard(cardNumber: selectedCardModel.cardNumber, completion: { [weak self] in
            self?.getCreditCards()
            // Reload table view, wait 0.1 sec to make sure that collection views inside the table view is finished layouting subviews
            guard let self = self else { return }
            self.viewModel.deleteCreditCardAtIndex(selectedCardIndex)
            self.paymentCardTableViewCell?.setNumberOfSavedCards(self.viewModel.dataCount)
            self.paymentCardTableViewCell?.updateSelectedIndex()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                guard let self = self else { return }
                self.paymentCardTableViewCell?.collectionView.reloadData()
                self.tableView.reloadData()
                SnackBarSuccess.make(in: self.view, message: "Delete success", duration: .lengthShort).show()
                self.paymentAddCardTableViewCell?.setEnableButtons(isEnable: true)
            }
        }, onError: { errorMessage in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                SnackBarDanger.make(in: self.view, message: "Delete failed", duration: .lengthShort).show()
                self.paymentAddCardTableViewCell?.setEnableButtons(isEnable: true)
            }
        })
    }
    
    func updateCardButtonPressed() {
        let storyboard = UIStoryboard(name: "Checkout", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: UpdateCardViewController.identifier) as? UpdateCardViewController else { return }
        vc.delegate = self
        guard let selectedIndex = paymentCardTableViewCell?.selectedViewIndex else { return }
        let cardModel = viewModel.getDataAtIndex(selectedIndex)
        vc.configure(oldCard: cardModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - AddCardViewControllerDelegate

extension PaymentViewController: AddCardViewControllerDelegate {
    
    func newCreditCardAdded(newCreditCard: CreditCardModel) {
        viewModel.appendCreditCard(newCard: newCreditCard)
        DispatchQueue.main.async { [weak self] in
            self?.paymentCardTableViewCell?.collectionView.reloadData()
            self?.tableView.reloadData()
            guard let self = self else { return }
            SnackBarSuccess.make(in: self.view, message: "New card added", duration: .lengthShort).show()
        }
    }
}

// MARK: - UpdateCardViewControllerDelegate

extension PaymentViewController: UpdateCardViewControllerDelegate {
    
    func creditCardUpdated() {
        getCreditCards()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            SnackBarSuccess.make(in: self.view, message: "Update success", duration: .lengthShort).show()
        }
    }
}
