//
//  InteractiveAlertViewController.swift
//  Stockraven
//
//  Created by Robert Canton on 2020-05-17.
//

import Foundation
import UIKit

class InteractiveAlertViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var stock:Stock
    var tableView:UITableView!
    var headerView:InteractiveAlertHeaderView!
    
    init(stock:Stock) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.systemBackground
        view.addSubview(tableView)
        tableView.constraintToSuperview()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let headerFrame = CGRect(x: 0, y: 0,
                                 width: view.bounds.width,
                                 height: view.bounds.height / 2)
        
        headerView = InteractiveAlertHeaderView(frame: headerFrame,
                                                stock: stock)
        
        tableView.tableHeaderView =  headerView
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "123"
        return cell
    }
    
}
