//
//  OrderConfirmedViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 07/08/23.
//

import UIKit

class OrderConfirmedViewController: UIViewController {

    static let identifier = "OrderConfirmedViewController"
    
    @IBOutlet weak var ctaButton: UIButton! {
        didSet {
            ctaButton.addTarget(self, action: #selector(continueShoppingButtonPressed), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var goToOrdersButton: RoundedButton! {
        didSet {
            goToOrdersButton.addTarget(self, action: #selector(goToOrdersButtonPressed), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarController?.tabBar.isHidden = true
    }

    @objc private func goToOrdersButtonPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func continueShoppingButtonPressed() {
        guard let tabBar = tabBarController else { return }
        navigationController?.popToRootViewControllerWithHandler {
            tabBar.selectedIndex = 0
        }
    }
}
