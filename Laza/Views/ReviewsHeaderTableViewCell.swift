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

    static let identifier = "ReviewsHeaderTableViewCell"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    weak var delegate: ReviewsHeaderTableViewCellDelegate?
    
    @IBOutlet weak var addReviewButton: RoundedButton! {
        didSet {
            addReviewButton.addTarget(self, action: #selector(addReviewButtonPressed), for: .touchUpInside)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @objc private func addReviewButtonPressed() {
        delegate?.addReviewButtonPressed()
    }
}
