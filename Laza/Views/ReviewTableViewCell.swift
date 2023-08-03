//
//  ReviewTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 02/08/23.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    static let identifier = "ReviewTableViewCell"
    static let nib = UINib(nibName: identifier, bundle: nil)

    @IBOutlet private weak var profileImageView: UIImageView! {
        didSet {
            profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        }
    }
    
    @IBOutlet private weak var nameLabel: UILabel!
    
    @IBOutlet private weak var datePosted: UILabel!
    
    @IBOutlet private weak var ratingNumberLabel: UILabel!
    
    @IBOutlet private weak var firstStar: UIImageView!
    @IBOutlet private weak var secondStar: UIImageView!
    @IBOutlet private weak var thirdStar: UIImageView!
    @IBOutlet private weak var fourthStar: UIImageView!
    @IBOutlet private weak var fifthStar: UIImageView!
    
    @IBOutlet weak var reviewDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = ColorUtils.shared.getColor(color: .WhiteBG)
    }
    
}
