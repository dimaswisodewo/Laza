//
//  CartDetailViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 07/08/23.
//

import UIKit

protocol CartDetailViewControllerDelegate: AnyObject {
    
    func addressButtonPressed()
    
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

    @IBOutlet weak var subtotalLabel: UILabel!
    
    @IBOutlet weak var shippingCostLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    weak var delegate: CartDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView() {
        let nib = UINib(nibName: String(describing: ListViewItem.self), bundle: nil)
        
        let paymentView = nib.instantiate(withOwner: nil).first as! UIView
        paymentMethodViewItem.addSubview(paymentView)
        paymentView.frame = paymentMethodViewItem.bounds
        let listViewItemPayment = paymentView as! ListViewItem
        listViewItemPayment.setTitle(title: "Visa Classic")
        listViewItemPayment.setSubtitle(subtitle: "**** 7880")
        
        let addressView = nib.instantiate(withOwner: nil).first as! UIView
        deliveryAddressViewItem.addSubview(addressView)
        addressView.frame = deliveryAddressViewItem.bounds
        let listViewItemAddress = addressView as! ListViewItem
        listViewItemAddress.setTitle(title: "Jl. Subur Raya, Menteng Atas")
        listViewItemAddress.setSubtitle(subtitle: "Jakarta Selatan")
    }
    
    @objc private func addressButtonPressed() {
        dismiss(animated: true)
        delegate?.addressButtonPressed()
    }
    
    @objc private func cardButtonPressed() {
        dismiss(animated: true)
        delegate?.cardButtonPressed()
    }
}
