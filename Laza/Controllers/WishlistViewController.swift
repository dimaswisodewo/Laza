//
//  WishlistViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

class WishlistViewController: UIViewController {

    static let identifier = "WishlistViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarItemImage()
    }
    
    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Wishlist"
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 12)
        label.sizeToFit()
        
        navigationController?.tabBarItem.selectedImage = UIImage(view: label)
    }
}
