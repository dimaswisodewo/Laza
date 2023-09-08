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
    
    var isSwitchOn: Bool { return switchButton.isOn }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(switchButton)
        setupConstraints()
        setupSwitchButton()
        registerActions()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        contentView.addSubview(switchButton)
        setupConstraints()
        setupSwitchButton()
        registerActions()
    }
    
    @objc private func switchButtonPressed() {
        setEnableDarkMode(isEnabled: switchButton.isOn)
        DataPersistentManager.shared.saveDarkModeConfigToUserDefault(isOn: switchButton.isOn)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            switchButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            switchButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupSwitchButton() {
        guard let isDarkMode = DataPersistentManager.shared.getDarkModeConfigFromUserDefault() else {
            print("Failed get darkmode config from user default")
            return
        }
        switchButton.isOn = isDarkMode
        setEnableDarkMode(isEnabled: isDarkMode)
    }
    
    private func setEnableDarkMode(isEnabled: Bool) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let appDelegate = windowScene.windows.first else { return }
        appDelegate.overrideUserInterfaceStyle = isEnabled ? .dark : .light
    }
    
    private func registerActions() {
        switchButton.addTarget(self, action: #selector(switchButtonPressed), for: .touchUpInside)
    }
}
