//
//  SideMenuProfileTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 04/08/23.
//

import UIKit

class SideMenuProfileTableViewCell: UITableViewCell {
    
    class var identifier: String { return String(describing: self) }
    class var nib: UINib { return UINib(nibName: identifier, bundle: nil) }

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.layer.cornerRadius = profileImage.frame.width / 2
            profileImage.contentMode = .scaleAspectFill
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = nil
    }
    
    func configure(profile: Profile) {
        nameLabel.text = profile.fullName
        if let imageUrl = profile.imageUrl {
            profileImage.loadAndCache(url: imageUrl)
        }
    }
}
