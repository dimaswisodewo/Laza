//
//  SideMenuViewController.swift
//  Laza
//
//  Created by Dimas Wisodewo on 30/07/23.
//

import UIKit

struct SideMenuModel {
    var icon: UIImage
    var title: String
}

class SideMenuViewController: UIViewController {
    
    class var identifier: String { return String(describing: self) }

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(SideMenuTableViewCell.self, forCellReuseIdentifier: SideMenuTableViewCell.identifier)
        }
    }
    
    private var sideMenus = [
        SideMenuModel(icon: UIImage(systemName: "lock")!, title: "Update Password"),
        SideMenuModel(icon: UIImage(systemName: "person.fill.xmark")!, title: "Log Out")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

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
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
}
