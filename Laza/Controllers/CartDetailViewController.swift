//
//  CartDetailViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 07/08/23.
//

import UIKit

class CartDetailViewController: UIViewController {

    static let identifier = "CartDetailViewController"
    
    @IBOutlet weak var bgView: UIView! {
        didSet {
            bgView.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var deliveryAddressViewItem: ListViewItem!
    
    @IBOutlet weak var deliveryAddressDetailButton: UIButton!
    
    @IBOutlet weak var paymentMethodViewItem: ListViewItem!
    
    @IBOutlet weak var paymentMethodDetailButton: UIButton!

    @IBOutlet weak var subtotalLabel: UILabel!
    
    @IBOutlet weak var shippingCostLabel: UILabel!
    
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
