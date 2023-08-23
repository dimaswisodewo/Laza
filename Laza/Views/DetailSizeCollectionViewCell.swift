//
//  DetailSizeCollectionViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 02/08/23.
//

import UIKit

class DetailSizeCollectionViewCell: UICollectionViewCell {
    class var identifier: String { return String(describing: self) }
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ColorUtils.shared.getColor(color: .WhiteButtonSecondary)
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    private let sizeLabel: UILabel = {
        let label = UILabel()
        label.text = "Size"
        label.textAlignment = .center
        label.font = FontUtils.shared.getFont(font: .Poppins, weight: .semibold, size: 18)
        label.textColor = ColorUtils.shared.getColor(color: .TextPrimary)
        return label
    }()
    
    var isSubscribedDeactivateCell = false
    var isCellSelected = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(containerView)
        containerView.addSubview(sizeLabel)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureSize(size: String) {
        sizeLabel.text = size
    }
    
    func setSelected(isSelected: Bool) {
        isCellSelected = isSelected
        if isSelected {
            containerView.backgroundColor = ColorUtils.shared.getColor(color: .PurpleButton)
            sizeLabel.textColor = .white
        } else {
            containerView.backgroundColor = ColorUtils.shared.getColor(color: .WhiteButtonSecondary)
            sizeLabel.textColor = ColorUtils.shared.getColor(color: .TextPrimary)
        }
    }
    
    private func setupConstraints() {
        containerView.frame = contentView.bounds
        sizeLabel.frame = containerView.bounds
    }
}
