//
//  MonoHomeVC.swift
//  Nano
//
//  Created by Robert Canton on 2020-08-09.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class MonoHomeVC:UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.constraintToSuperview()
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.register(MonoHeaderCell.self, forCellReuseIdentifier: "headerCell")
        tableView.register(MonoStatusCell.self, forCellReuseIdentifier: "statusCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
    }
}

extension MonoHomeVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! MonoHeaderCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "statusCell", for: indexPath) as! MonoStatusCell
            return cell
        default:
            break
        }
        
        return UITableViewCell()
        
    }
}
