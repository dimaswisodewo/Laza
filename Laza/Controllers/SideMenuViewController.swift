//
//  SideMenuViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 30/07/23.
//

import UIKit

protocol SideMenuViewControllerDelegate: AnyObject {
    
    func didSelectUpdatePassword()
    
    func didSelectLogOut()
}

enum SideMenuType {
    case darkMode
    case accountInformation
    case updatePassword
    case order
    case cards
    case wishlist
    case settings
    case logOut
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
            tableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        }
    }
    
    private var sideMenus = [
        SideMenuModel(icon: UIImage(systemName: "sun.max")!, title: "Dark Mode", type: .darkMode),
        SideMenuModel(icon: UIImage(systemName: "exclamationmark.circle")!, title: "Account Information", type: .accountInformation),
        SideMenuModel(icon: UIImage(systemName: "exclamationmark.lock")!, title: "Password", type: .updatePassword),
        SideMenuModel(icon: UIImage(named: "Bag")!.withRenderingMode(.alwaysTemplate), title: "Order", type: .order),
        SideMenuModel(icon: UIImage(named: "Wallet")!.withRenderingMode(.alwaysTemplate), title: "My Cards", type: .cards),
        SideMenuModel(icon: UIImage(named: "Wishlist")!.withRenderingMode(.alwaysTemplate), title: "Wishlist", type: .wishlist),
        SideMenuModel(icon: UIImage(systemName: "gearshape")!, title: "Settings", type: .settings),
        SideMenuModel(icon: UIImage(systemName: "rectangle.portrait.and.arrow.right")!, title: "Logout", type: .logOut)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

// MARK: - UITableView Delegate & Data Source

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sideMenus.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SideMenuTableViewCell.identifier) as? SideMenuTableViewCell else {
            return UITableViewCell()
        }
        
        let model = sideMenus[indexPath.row]
        cell.configure(model: model)
        
        if model.type == .logOut {
            cell.setTintColor(tintColor: .systemRed)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let type = sideMenus[indexPath.row].type
        switch type {
        case .darkMode:
            break
        case .accountInformation:
            break
        case .updatePassword:
            delegate?.didSelectUpdatePassword()
        case .order:
            break
        case .cards:
            break
        case .wishlist:
            break
        case .settings:
            break
        case .logOut:
            delegate?.didSelectLogOut()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
