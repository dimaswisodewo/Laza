//
//  ReviewsHeaderTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 03/08/23.
//

import UIKit

protocol ReviewsHeaderTableViewCellDelegate: AnyObject {
    
    func addReviewButtonPressed()
}

class ReviewsHeaderTableViewCell: UITableViewCell {

    enum Star: String {
        case fullStar = "star.fill"
        case halfStar = "star.leadinghalf.filled"
        case emptyStar = "star"
    }
    
    static let identifier = "ReviewsHeaderTableViewCell"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    weak var delegate: ReviewsHeaderTableViewCellDelegate?
    
    @IBOutlet weak var reviewsCountLabel: UILabel!
    @IBOutlet weak var reviewsAverageLabel: UILabel!
    
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!
    @IBOutlet weak var fourthStar: UIImageView!
    @IBOutlet weak var fifthStar: UIImageView!
    
    @IBOutlet weak var addReviewButton: RoundedButton! {
        didSet {
            addReviewButton.addTarget(self, action: #selector(addReviewButtonPressed), for: .touchUpInside)
        }
    }
    
    
    @objc private func addReviewButtonPressed() {
        delegate?.addReviewButtonPressed()
    }
    
    func configure(reviewsCount: Int, reviewsAverage: Double) {
        reviewsCountLabel.text = "\(reviewsCount) Reviews"
        reviewsAverageLabel.text = String(reviewsAverage)
        configureRating(rating: reviewsAverage)
    }
    
    private func configureRating(rating: Double) {
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
