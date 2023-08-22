//
//  SideMenuViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 30/07/23.
//

import UIKit

protocol SideMenuViewControllerDelegate: AnyObject {
    
    func didSelectProfile()
    
    func didSelectDarkMode()
    
    func didSelectUpdatePassword()
    
    func didSelectLogOut()
    
    func didSelectCards()
    
    func didSelectWishlist()
    
    func didSelectOrders()
}

enum SideMenuType: Int, CaseIterable {
    case profile = 0
    case darkMode = 1
    case accountInformation = 2
    case updatePassword = 3
    case order = 4
    case cards = 5
    case wishlist = 6
    case settings = 7
    case logOut = 8
}

struct SideMenuModel {
    var icon: UIImage
    var title: String
    var type: SideMenuType
}

class SideMenuViewController: UIViewController {
    
    class var identifier: String { return String(describing: self) }
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.bounces = false
            tableView.register(SideMenuProfileTableViewCell.nib, forCellReuseIdentifier: SideMenuProfileTableViewCell.identifier)
            tableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
            tableView.register(SideMenuSwitchTableViewCell.self, forCellReuseIdentifier: SideMenuSwitchTableViewCell.identifier)
        }
    }
    
    private let logoutView: SideMenuView = {
        let view = SideMenuView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sideMenus = [
        SideMenuModel(
            icon: UIImage(named: "Profile")!,
            title: "",
            type: .profile
        ),
        SideMenuModel(
            icon: UIImage(systemName: "sun.max")!,
            title: "Dark Mode",
            type: .darkMode
        ),
        SideMenuModel(
            icon: UIImage(systemName: "exclamationmark.circle")!,
            title: "Account Information",
            type: .accountInformation
        ),
        SideMenuModel(
            icon: UIImage(systemName: "exclamationmark.lock")!,
            title: "Password",
            type: .updatePassword
        ),
        SideMenuModel(
            icon: UIImage(named: "Bag")!.withRenderingMode(.alwaysTemplate),
            title: "Order",
            type: .order
        ),
        SideMenuModel(
            icon: UIImage(named: "Wallet")!.withRenderingMode(.alwaysTemplate),
            title: "My Cards",
            type: .cards
        ),
        SideMenuModel(
            icon: UIImage(named: "Wishlist")!.withRenderingMode(.alwaysTemplate),
            title: "Wishlist",
            type: .wishlist
        ),
        SideMenuModel(
            icon: UIImage(systemName: "gearshape")!,
            title: "Settings",
            type: .settings
        ),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(logoutView)
        
        setConstraints()
        
        setupLogoutView()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            logoutView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            logoutView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logoutView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
            logoutView.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private var profile: Profile?
    
    func configure(profile: Profile) {
        self.profile = profile
    }
    
    private func setupLogoutView() {
        logoutView.configure(
            model: SideMenuModel(
                icon: UIImage(systemName: "rectangle.portrait.and.arrow.right")!,
                title: "Logout",
                type: .logOut
            )
        )
        logoutView.setTintColor(tintColor: .systemRed)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(logoutTapped))
        logoutView.addGestureRecognizer(gesture)
    }
    
    @objc private func logoutTapped() {
        delegate?.didSelectLogOut()
    }
}

// MARK: - UITableView Delegate & Data Source

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = sideMenus[indexPath.row]
        
        // Dequeue SideMenuProfileTableViewCell
        if model.type == .profile {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuProfileTableViewCell.identifier) as? SideMenuProfileTableViewCell else {
                return UITableViewCell()
            }
            if let profile = self.profile {
                cell.configure(profile: profile)
            }
            return cell
        }
        
        // Dequeue SideMenuSwitchTableViewCell
        if model.type == .darkMode {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuSwitchTableViewCell.identifier) as? SideMenuSwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(model: model)
            return cell
        }
        
        // Dequeue SideMenuTableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier) as? SideMenuTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let type = sideMenus[indexPath.row].type
        switch type {
        case .profile:
            delegate?.didSelectProfile()
        case .darkMode:
            delegate?.didSelectDarkMode()
            break
        case .accountInformation:
            break
        case .updatePassword:
            delegate?.didSelectUpdatePassword()
        case .order:
            delegate?.didSelectOrders()
        case .cards:
            delegate?.didSelectCards()
        case .wishlist:
            delegate?.didSelectWishlist()
        case .settings:
            break
        case .logOut:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case SideMenuType.profile.rawValue:
            return UITableView.automaticDimension
        default:
            return 60
        }
    }
}
