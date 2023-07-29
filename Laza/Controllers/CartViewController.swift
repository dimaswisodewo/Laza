//
//  CartViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 26/07/23.
//

import UIKit

class CartViewController: UIViewController {

    static let identifier = "CartViewController"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTabBarItemImage()
    }
    

    private func setupTabBarItemImage() {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.text = "Cart"
        label.font = UIFont(name: "Inter-Medium", size: 11)
        label.sizeToFit()
        
        tabBarItem.selectedImage = UIImage(view: label)
    }
}
