//
//  EmptyTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 16/08/23.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {
    static let identifier = "EmptyTableViewCell"
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
}
