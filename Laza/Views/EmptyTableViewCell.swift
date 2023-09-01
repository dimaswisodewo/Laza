//
//  EmptyTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 16/08/23.
//

import UIKit
import SkeletonView

class EmptyTableViewCell: UITableViewCell {
    static let identifier = "EmptyTableViewCell"
    static var nib: UINib { return UINib(nibName: identifier, bundle: nil) }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.isSkeletonable = true
        }
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func showSkeleton() {
        print("Show skeleton")
        titleLabel.showAnimatedGradientSkeleton()
    }
    
    func hideSkeleton() {
        print("Hide skeleton")
        titleLabel.hideSkeleton()
    }
}
