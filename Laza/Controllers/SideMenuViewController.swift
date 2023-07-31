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
    case updatePassword
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
        SideMenuModel(icon: UIImage(systemName: "lock")!, title: "Update Password", type: .updatePassword),
        SideMenuModel(icon: UIImage(systemName: "person.fill.xmark")!, title: "Log Out", type: .logOut)
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
        
        cell.configure(model: sideMenus[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = sideMenus[indexPath.row].type
        switch type {
        case .updatePassword:
            delegate?.didSelectUpdatePassword()
        case .logOut:
            delegate?.didSelectLogOut()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
