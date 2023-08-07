//
//  ListViewItem.swift
//  Laza
//
//  Created by Dimas Wisodewo on 07/08/23.
//

import UIKit

@IBDesignable class ListViewItem: UIView {
    
    @IBOutlet weak var itemImageView: RoundedImageView!
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    @IBOutlet weak var itemSubtitleLabel: UILabel!
    
    @IBOutlet weak var itemRightImage: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
    }
    
    private func setupView() {
        self.layer.cornerRadius = 14
    }
}
