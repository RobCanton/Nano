//
//  UserSettingsViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-06.
//

import Foundation
import UIKit
import Firebase

class UserSettingsViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "Settings"
        
        navigationController?.navigationBar.barTintColor = UIColor.secondarySystemBackground
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(handleClose))
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        tableView.constraintToSuperview()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UserProfileSettingsCell.self, forCellReuseIdentifier: "profileCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    @objc func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func logout() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            do {
                try Auth.auth().signOut()
            } catch {
            
            }
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 3:
            return 2
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath) as! UserProfileSettingsCell
            cell.configure()
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Get Premium"
            cell.textLabel?.textColor = Theme.current.primary
            return cell
        case 2:
            switch indexPath.row {
            case 0:
                break
            case 1:
                break
            default:
                break
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Notifications"
            cell.accessoryType = .disclosureIndicator
            //cell.textLabel?.textColor = Theme.current.primary
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Logout"
            cell.textLabel?.textColor = UIColor.systemRed
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            let vc = CreateProfileViewController()
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 1:
            let vc = SubscribeViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 2:
            logout()
            break
        default:
            break
        }
    }
    
    
    
    
    
}

extension UserSettingsViewController: CreateProfileDelegate {
    func createProfileDidComplete() {
        self.tableView.reloadData()
    }
}
