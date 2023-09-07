//
//  CartDetailViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 07/08/23.
//

import UIKit

protocol CartDetailViewControllerDelegate: AnyObject {
    
    func addressButtonPressed(loadedAddress: [Address])
    
    func cardButtonPressed()
}

class CartDetailViewController: UIViewController {

    static let identifier = "CartDetailViewController"
    
    @IBOutlet weak var bgView: UIView! {
        didSet {
            bgView.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var deliveryAddressViewItem: UIView!
    
    @IBOutlet weak var deliveryAddressDetailButton: UIButton! {
        didSet {
            deliveryAddressDetailButton.addTarget(self, action: #selector(addressButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var paymentMethodViewItem: UIView!
    
    @IBOutlet weak var paymentMethodDetailButton: UIButton! {
        didSet {
            paymentMethodDetailButton.addTarget(self, action: #selector(cardButtonPressed), for: .touchUpInside)
        }
    }

    @IBOutlet weak var subtotalLabel: UILabel! {
        didSet {
            subtotalLabel.text = "$\(0)"
        }
    }
    
    @IBOutlet weak var shippingCostLabel: UILabel! {
        didSet {
            shippingCostLabel.text = "$\(0)"
        }
    }
    
    @IBOutlet weak var totalLabel: UILabel! {
        didSet {
            totalLabel.text = "$\(0)"
        }
    }
    
    private var listViewItemAddress: ListViewItem?
    private var listViewItemPayment: ListViewItem?
    
    private let addressEmptyLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14)
        label.textColor = ColorUtils.shared.getColor(color: .TextPrimary)
        label.textAlignment = .center
        label.text = "No address added"
        return label
    }()
    
    private let paymentMethodEmptyLabel: UILabel = {
        let label = UILabel()
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .regular, size: 14)
        label.textColor = ColorUtils.shared.getColor(color: .TextPrimary)
        label.textAlignment = .center
        label.text = "No payment method added"
        return label
    }()
    
    weak var delegate: CartDetailViewControllerDelegate?
    
    private var viewModel: CartDetailViewModel?
    private var selectedAddress: Address? {
        didSet {
            guard let selectedAddress = self.selectedAddress else { return }
            setSelectedAddress?(selectedAddress)
        }
    }
    private var selectedPayment: CreditCardModel? {
        didSet {
            guard let selectedPayment = self.selectedPayment else { return }
            setSelectedPayment?(selectedPayment)
        }
    }
    var setSelectedAddress: ((Address) -> Void)?
    var setSelectedPayment: ((CreditCardModel) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyModel()
        
        setupView()
        
        if let address = selectedAddress {
            addressEmptyLabel.isHidden = true
            listViewItemAddress?.hideSkeleton()
            listViewItemAddress?.isHidden = false
            setupAddressView(address: address)
        } else {
            listViewItemAddress?.showSkeleton()
            getAllAddress()
        }
        
        if let creditCard = selectedPayment {
            setupCardView(card: creditCard)
            paymentMethodEmptyLabel.isHidden = true
            listViewItemPayment?.hideSkeleton()
            listViewItemPayment?.isHidden = false
        } else {
            paymentMethodEmptyLabel.isHidden = false
            listViewItemPayment?.isHidden = true
        }
    }
    
    func configure(address: Address?, payment: CreditCardModel?, orderInfo: OrderInfo) {
        viewModel = CartDetailViewModel(orderInfo: orderInfo)
        selectedAddress = address
        selectedPayment = payment
    }
    
    func applyModel() {
        guard let orderInfo = viewModel?.orderInfo else { return }
        subtotalLabel.text = FormatterManager.shared.formattedToPrice(price: orderInfo.subTotal as NSNumber)
        shippingCostLabel.text = FormatterManager.shared.formattedToPrice(price: orderInfo.shippingCost as NSNumber)
        totalLabel.text = FormatterManager.shared.formattedToPrice(price: orderInfo.total as NSNumber)
    }
    
    private func getAllAddress() {
        guard let viewModel = self.viewModel else { return }
        viewModel.getAllAddress(completion: {
            // Get primary address
            let primaryAddress = viewModel.addresses.first
            DispatchQueue.main.async { [weak self] in
                self?.selectedAddress = primaryAddress
                // Primary address does exists
                if let primaryAddress = primaryAddress {
                    self?.addressEmptyLabel.isHidden = true
                    self?.listViewItemAddress?.hideSkeleton()
                    self?.listViewItemAddress?.isHidden = false
                    self?.setupAddressView(address: primaryAddress)
                } else {
                    self?.addressEmptyLabel.isHidden = false
                    self?.listViewItemAddress?.hideSkeleton()
                    self?.listViewItemAddress?.isHidden = true
                }
            }
        }, onError: { errorMessage in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
            }
        })
    }
    
    private func getAllCreditCards() {
        guard let primaryCardNumber = DataPersistentManager.shared.getPrimaryCard() else {
            print("Primary card does not exist")
            return
        }
        DataPersistentManager.shared.fetchCardData(cardNumber: primaryCardNumber) { [weak self] result in
            switch result {
            case .success(let model):
                self?.paymentMethodEmptyLabel.isHidden = true
                self?.listViewItemPayment?.hideSkeleton()
                self?.listViewItemPayment?.isHidden = false
                self?.selectedPayment = model
                self?.setupCardView(card: model)
            case .failure(let error):
                print(error.localizedDescription)
                self?.paymentMethodEmptyLabel.isHidden = false
                self?.listViewItemPayment?.hideSkeleton()
                self?.listViewItemPayment?.isHidden = true
            }
        }
    }
    
    private func setupCardView(card: CreditCardModel) {
        listViewItemPayment?.setTitle(title: card.cardNumber)
        listViewItemPayment?.setSubtitle(subtitle: card.owner)
    }
    
    private func setupAddressView(address: Address) {
        listViewItemAddress?.setTitle(title: "\(address.city), \(address.country)")
        listViewItemAddress?.setSubtitle(subtitle: address.receiverName)
    }
    
    private func setupView() {
        let nib = UINib(nibName: String(describing: ListViewItem.self), bundle: nil)
        // Payment method
        let cardView = nib.instantiate(withOwner: nil).first as! UIView
        paymentMethodViewItem.addSubview(cardView)
        cardView.frame = paymentMethodViewItem.bounds
        listViewItemPayment = cardView as? ListViewItem
        listViewItemPayment?.setImage(image: UIImage(named: "PaymentCreditCard"))
        listViewItemPayment?.setupSkeleton()
        // Address
        let addressView = nib.instantiate(withOwner: nil).first as! UIView
        deliveryAddressViewItem.addSubview(addressView)
        addressView.frame = deliveryAddressViewItem.bounds
        listViewItemAddress = addressView as? ListViewItem
        listViewItemAddress?.setImage(image: UIImage(named: "Address"))
        listViewItemAddress?.setupSkeleton()
        // Empty label payment method
        paymentMethodViewItem.addSubview(paymentMethodEmptyLabel)
        paymentMethodEmptyLabel.frame = paymentMethodViewItem.bounds
        paymentMethodEmptyLabel.isHidden = true
        // Empty label address
        deliveryAddressViewItem.addSubview(addressEmptyLabel)
        addressEmptyLabel.frame = deliveryAddressViewItem.bounds
        addressEmptyLabel.isHidden = true
    }
    
    @objc private func addressButtonPressed() {
        guard let viewModel = self.viewModel else { return }
        dismiss(animated: true)
        delegate?.addressButtonPressed(loadedAddress: viewModel.addresses)
    }
    
    @objc private func cardButtonPressed() {
        dismiss(animated: true)
        delegate?.cardButtonPressed()
    }
}
