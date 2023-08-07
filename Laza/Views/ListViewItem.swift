//
//  ListViewItem.swift
//  Laza
//
//  Created by Dimas Wisodewo on 07/08/23.
//

import UIKit

@IBDesignable class ListViewItem: RoundedView {

    @IBOutlet weak var itemImageView: RoundedImageView!
    
    @IBOutlet weak var itemTitleLabel: UILabel!
    
    @IBOutlet weak var itemSubtitleLabel: UILabel!
    
    @IBOutlet weak var itemRightImage: UIImageView!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
