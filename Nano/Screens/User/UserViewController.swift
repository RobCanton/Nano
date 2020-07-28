//
//  UserViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-05.
//

import Foundation
import UIKit
import Firebase

class UserViewController:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(handleLogout))
    }
    
    @objc func handleLogout() {
        do {
            try Auth.auth().signOut()
        } catch {
            
        }
    }
}
