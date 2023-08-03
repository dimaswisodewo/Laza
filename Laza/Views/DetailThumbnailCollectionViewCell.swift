//
//  DetailThumbnailCollectionViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 01/08/23.
//

import UIKit

class DetailThumbnailCollectionViewCell: UICollectionViewCell {
    class var identifier: String { return String(describing: self) }
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .lightGray
        iv.layer.cornerRadius = 20
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureImage(image: UIImage) {
        imageView.image = image
    }
    
    private func setupConstraints() {
        imageView.frame = contentView.bounds
    }
}
