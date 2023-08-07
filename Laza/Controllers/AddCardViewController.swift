//
//  AddCardViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 07/08/23.
//

import UIKit

class AddCardViewController: UIViewController {

    static let identifier = "AddCardViewController"
    
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
    
    @IBOutlet weak var cardOwnerField: CustomTextField! {
        didSet {
            cardOwnerField.setTitle(title: "Card Owner")
        }
    }
    
    @IBOutlet weak var cardNumberField: CustomTextField! {
        didSet {
            cardNumberField.setTitle(title: "Card Number")
        }
    }
    
    @IBOutlet weak var expField: CustomTextField! {
        didSet {
            expField.setTitle(title: "EXP")
        }
    }
    
    @IBOutlet weak var cvvField: CustomTextField! {
        didSet {
            cvvField.setTitle(title: "CVV")
        }
    }
    
    var onDismiss: (() -> Void)? // Present CartDetailViewController again after dismiss
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
    }
    
    // End editing on touch began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @objc private func backButtonPressed() {
        navigationController?.popViewController(animated: true)
        onDismiss?()
    }

    @objc private func ctaButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
}
