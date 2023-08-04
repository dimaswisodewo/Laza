//
//  SideMenuSwitchTableViewCell.swift
//  Laza
//
//  Created by Dimas Wisodewo on 04/08/23.
//

import UIKit

class SideMenuSwitchTableViewCell: SideMenuTableViewCell {

    class override var identifier: String { return String(describing: self) }
    
    private let switchButton: UISwitch = {
        let sb = UISwitch()
        sb.translatesAutoresizingMaskIntoConstraints = false
        return sb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(switchButton)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        contentView.addSubview(switchButton)
        setupConstraints()
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            switchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
}
