//
//  ChoosePaymentTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 10/08/23.
//

import UIKit

class ChoosePaymentTableViewCell: UITableViewCell {
    static let identifier = "ChoosePaymentTableViewCell"
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var paymentName: UIImageView! {
        didSet {
            paymentName.contentMode = .scaleAspectFit
            paymentName.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var checkmarkImage: UIImageView! {
        didSet {
            checkmarkImage.contentMode = .scaleAspectFit
        }
    }
    
    private(set) var paymentTitle = ""
    private(set) var isCheckmarkActive = false
    
    var isSubscribedDeactivateCheckmark = false
    
    func configure(paymentTitle: String, paymentImage: UIImage?) {
        self.paymentTitle = paymentTitle
        paymentName.image = paymentImage
    }
    
    func setCheckmarkImage(isActive: Bool) {
        let uiImage = isActive ? UIImage(systemName: "checkmark.circle.fill") : nil
        checkmarkImage.image = uiImage
        isCheckmarkActive = isActive
    }
    
    func toggleCheckmarkImage() {
        setCheckmarkImage(isActive: !isCheckmarkActive)
    }
}
