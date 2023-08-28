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
    
    weak var delegate: CartDetailViewControllerDelegate?
    
    private var viewModel: CartDetailViewModel?
    private var selectedAddress: Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyModel()
        
        if let address = selectedAddress {
            setupAddressView(address: address)
        } else {
            getAllAddress()
        }
    }
    
    func configure(address: Address?, orderInfo: OrderInfo) {
        viewModel = CartDetailViewModel(orderInfo: orderInfo)
        selectedAddress = address
    }
    
    func applyModel() {
        guard let orderInfo = viewModel?.orderInfo else { return }
        subtotalLabel.text = "$\(orderInfo.subTotal)"
        shippingCostLabel.text = "$\(orderInfo.shippingCost)"
        totalLabel.text = "$\(orderInfo.total)"
    }
    
    private func getAllAddress() {
        guard let viewModel = self.viewModel else { return }
        viewModel.getAllAddress(completion: {
            guard let firstAddress = viewModel.addresses.first else { return }
            DispatchQueue.main.async { [weak self] in
                self?.selectedAddress = firstAddress
                self?.setupAddressView(address: firstAddress)
            }
        }, onError: { errorMessage in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                SnackBarDanger.make(in: self.view, message: errorMessage, duration: .lengthShort).show()
            }
        })
    }
    
    private func setupCardView(card: CreditCardModel) {
        let nib = UINib(nibName: String(describing: ListViewItem.self), bundle: nil)
        let addressView = nib.instantiate(withOwner: nil).first as! UIView
        deliveryAddressViewItem.addSubview(addressView)
        addressView.frame = deliveryAddressViewItem.bounds
        let listViewItemAddress = addressView as! ListViewItem
        listViewItemAddress.setTitle(title: card.cardNumber)
        listViewItemAddress.setSubtitle(subtitle: card.owner)
    }
    
    private func setupAddressView(address: Address) {
        let nib = UINib(nibName: String(describing: ListViewItem.self), bundle: nil)
        let addressView = nib.instantiate(withOwner: nil).first as! UIView
        deliveryAddressViewItem.addSubview(addressView)
        addressView.frame = deliveryAddressViewItem.bounds
        let listViewItemAddress = addressView as! ListViewItem
        listViewItemAddress.setTitle(title: "\(address.city), \(address.country)")
        listViewItemAddress.setSubtitle(subtitle: address.receiverName)
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
