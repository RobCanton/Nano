//
//  EditAlertOverlayVC.swift
//  Nano
//
//  Created by Robert Canton on 2020-07-30.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class EditAlertOverlayViewController:OverlayViewController {
    
    var tableView:UITableView!
    
    let item:MarketItem
    let alert:Alert?
    
    let editingMode:Bool
    
    init(item:MarketItem, alert:Alert?=nil) {
        self.alert = alert
        self.editingMode = alert != nil
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let title = editingMode ? "Edit Alert" : "New Alert"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: title, style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleDismiss))
        
        navigationController?.navigationBar.tintColor = UIColor.label
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        
        contentView.addSubview(tableView)
        tableView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        var headerFrame = CGRect.zero
        headerFrame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: headerFrame)
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(AlertConditionsCell.self, forCellReuseIdentifier: "conditionsCell")
       
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        //tableView.separatorColor = UIColor.separator.withAlphaComponent(0.25)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        let toolBar = UIToolbar()
        toolBar.isTranslucent = false
        toolBar.barTintColor = UIColor.systemBackground// navigationController?.navigationBar.barTintColor
        toolBar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        ], animated: false)
        
        contentView.addSubview(toolBar)
        toolBar.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: false)
        
        
        tableView.bottomAnchor.constraint(equalTo: toolBar.topAnchor).isActive = true
    }
    
    @objc func handleSave() {
        print("Save!")
    }

}

extension EditAlertOverlayViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conditionsCell", for: indexPath) as! AlertConditionsCell
        return cell
    }
}
