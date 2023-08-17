//
//  ListAddressItemTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 09/08/23.
//

import UIKit

class ListAddressItemTableViewCell: UITableViewCell {
    
    static let identifier = "ListAddressItemTableViewCell"
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var phoneLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    func configure(model: Address) {
        nameLabel.text = model.receiverName
        phoneLabel.text = model.phoneNumber
        addressLabel.text = "\(model.city), \(model.country)"
    }
    
}
