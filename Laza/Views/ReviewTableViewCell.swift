//
//  ReviewTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 02/08/23.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {
    
    enum Star: String {
        case fullStar = "star.fill"
        case halfStar = "star.leadinghalf.filled"
        case emptyStar = "star"
    }
    
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
    
    func configureRating(rating: Double) {
        var stars = [Star]()
        var colors = [UIColor]()
        var isHalfStarAdded = false
        for index in 1...5 {
            if isHalfStarAdded {
                stars.append(Star.emptyStar)
                colors.append(.lightGray)
                continue
            }
            let idx = Double(index)
            if idx <= rating {
                stars.append(Star.fullStar)
                colors.append(.systemYellow)
            } else if idx - rating > 0, idx - rating < 1 {
                stars.append(Star.halfStar)
                colors.append(.systemYellow)
                isHalfStarAdded = true
            } else {
                stars.append(Star.emptyStar)
                colors.append(.lightGray)
            }
        }
        ratingNumberLabel.text = String(rating)
        firstStar.image = UIImage(systemName: stars[0].rawValue)
        secondStar.image = UIImage(systemName: stars[1].rawValue)
        thirdStar.image = UIImage(systemName: stars[2].rawValue)
        fourthStar.image = UIImage(systemName: stars[3].rawValue)
        fifthStar.image = UIImage(systemName: stars[4].rawValue)
        firstStar.tintColor = colors[0]
        secondStar.tintColor = colors[1]
        thirdStar.tintColor = colors[2]
        fourthStar.tintColor = colors[3]
        fifthStar.tintColor = colors[4]
    }
}
