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
    
    var tableBottomAnchor:NSLayoutConstraint!
    
    var shouldDisplayKeyboard:Bool
    
    init(item:MarketItem, alert:Alert?=nil) {
        self.alert = alert
        self.editingMode = alert != nil
        self.item = item
        self.shouldDisplayKeyboard = false//!editingMode
        
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
        tableView.register(AlertMessageCell.self, forCellReuseIdentifier: "messageCell")
        tableView.register(AlertResetCell.self, forCellReuseIdentifier: "resetCell")
        tableView.backgroundColor = UIColor(hex: "171719")
        tableView.keyboardDismissMode = .onDrag
        //tableView.heightAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        //tableView.separatorInset = .zero
        //tableView.separatorStyle = .none
        
        //tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //tableView.separatorColor = UIColor.separator.withAlphaComponent(0.25)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
//        let toolBar = UIToolbar()
//        toolBar.isTranslucent = false
//        toolBar.barTintColor = UIColor.systemBackground// navigationController?.navigationBar.barTintColor
//        toolBar.setItems([
//            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
//            UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
//        ], animated: false)
//
//        contentView.addSubview(toolBar)
//        toolBar.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: false)
//
        
        tableBottomAnchor = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        tableBottomAnchor.isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldDisplayKeyboard {
            shouldDisplayKeyboard = false
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! AlertConditionsCell
            cell.textField.becomeFirstResponder()
        }
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleSave() {
        print("Save!")
    }

    
    @objc func keyboardWillShow(notification:Notification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else { return }
        //tableViewBottomAnchor.constant = -keyboardSize.height
        tableBottomAnchor.constant = -(keyboardSize.height)
        //commentBar.keyboardWillShow()
        view.layoutIfNeeded()
    }
        
    @objc func keyboardWillHide(notification:Notification) {
        
        tableBottomAnchor.constant = 0//commentBar.bounds.height
        //commentBar.keyboardWillHide()
        view.layoutIfNeeded()
    }
}

extension EditAlertOverlayViewController:UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        switch section {
//        case 0:
//            return "Conditions"
//        case 1:
//            return "Reset After"
//        default:
//            return nil
//        }
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
                cell.textLabel?.text = "Price"
                cell.accessoryType = .disclosureIndicator
                cell.backgroundColor = UIColor.systemBackground
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "conditionsCell", for: indexPath) as! AlertConditionsCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = "Reset After"
            cell.accessoryType = .disclosureIndicator
            cell.backgroundColor = UIColor.systemBackground
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath)
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.systemBackground
        navigationController?.pushViewController(vc, animated: true)
    }
}
