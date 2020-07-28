//
//  AlertOverlayViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-20.
//

import Foundation
import UIKit

class AlertOverlayViewController:OverlayViewController {
    
    var tableView:UITableView!
    let editingMode:Bool
    let item:MarketItem
    var alert:AlertEditable
    var submitButton:UIButton!
    
    init(item:MarketItem, alert:Alert?=nil) {
        self.editingMode = alert != nil
        self.item = item
        if alert != nil {
            self.alert = alert!.editable
        } else {
            self.alert = AlertEditable(id: "",
                                       type: .price,
                                       condtion: PriceCondition.isOver.rawValue,
                                       value: nil,
                                       reset: 2,
                                       enabled: 1)
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Alert", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleDismiss))
        
        navigationController?.navigationBar.tintColor = UIColor.label
        
        
        //navBar.titleLabel.text = editingMode ? "Edit Alert" : "New Alert"
        
        tableView = UITableView(frame: view.bounds, style: .grouped)
        //tableView.backgroundColor = UIColor(hex: "171719")
        contentView.addSubview(tableView)
        tableView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        var headerFrame = CGRect.zero
        headerFrame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: headerFrame)
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SegmentedControlCell.self, forCellReuseIdentifier: "segmentedCell")
        tableView.register(AlertTextFieldCell.self, forCellReuseIdentifier: "textCell")
        tableView.register(AlertSwitchCell.self, forCellReuseIdentifier: "switchCell")
        tableView.register(DeleteCell.self, forCellReuseIdentifier: "deleteCell")
        tableView.register(ResetCell.self, forCellReuseIdentifier: "resetCell")
        tableView.register(ActionCell.self, forCellReuseIdentifier: "actionCell")
        tableView.keyboardDismissMode = .onDrag
        
        tableView.separatorColor = UIColor.separator.withAlphaComponent(0.25)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        submitButton = UIButton(type: .system)
//        contentView.addSubview(submitButton)
//        submitButton.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: false)
//        submitButton.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
//        submitButton.constraintHeight(to: 52)
//        submitButton.setTitle("Create", for: .normal)
//        submitButton.setTitleColor(.white, for: .normal)
//        submitButton.backgroundColor = UIColor.secondarySystemBackground
//        submitButton.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        
//        let divider = UIView()
//        contentView.addSubview(divider)
//        divider.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: false)
//        divider.topAnchor.constraint(equalTo: submitButton.topAnchor).isActive = true
//        divider.constraintHeight(to: 0.5)
//        divider.backgroundColor = UIColor.separator
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let textFieldCell = tableView.cellForRow(at: IndexPath(row: 2, section: 0)) as? AlertTextFieldCell {
            textFieldCell.textField.isUserInteractionEnabled = true
            textFieldCell.textField.becomeFirstResponder()
        }
    }
    
    @objc func handleSave() {
        
        guard alert.isValid else {
            print("Unable to save alert: invalid")
            return
        }
        
        submitButton.isEnabled = false
        print("Save Alert: \(alert)")
        
        if editingMode {
            RavenAPI.patchAlert(alert) { alert in
                if alert != nil {
                    AlertManager.shared.updateAlert(alert!)
                    self.handleDismiss()
                } else {
                    self.submitButton.isEnabled = true
                }
            }
        } else {
            RavenAPI.createAlert(alert, for: item) { alert in
                if alert != nil {
                    AlertManager.shared.addAlert(alert!)
                    self.handleDismiss()
                } else {
                    self.submitButton.isEnabled = true
                }
            }
        }
        
    }
    
}

extension AlertOverlayViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       switch section {
       case 0:
            return 3
       case 1:
            return 3
       case 2:
        return 1
       case 3:
            return 0
       case 4:
            return editingMode ? 1 : 0
       default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return "Actions"
        case 2:
            return nil
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        switch section {
        case 1:
            return "In-app notifications will always be sent."
        case 2:
            return "Determines how long before this alert resets and can be triggered again."
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "segmentedCell", for: indexPath) as! SegmentedControlCell
                
                cell.segmentedControl.removeAllSegments()
                
                var selectedIndex = 0
                for i in 0..<AlertType.all.count {
                    let alertType = AlertType.all[i]
                    if alertType == alert.type {
                        selectedIndex = i
                    }
                    cell.segmentedControl.insertSegment(withTitle: alertType.title, at: i, animated: false)
                }
                
                cell.segmentedControl.selectedSegmentIndex = selectedIndex
                cell.indexPath = indexPath
                cell.delegate = self
                //cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                return cell
            case 1:
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "segmentedCell", for: indexPath) as! SegmentedControlCell
                    
                cell.segmentedControl.removeAllSegments()
                    
                var selectedIndex = 0
                for i in 0..<PriceCondition.all.count {
                    let condition = PriceCondition.all[i]
                    if condition.rawValue == alert.condtion {
                        selectedIndex = i
                    }
                    cell.segmentedControl.insertSegment(withTitle: condition.stringValue, at: i, animated: false)
                }
                
                cell.segmentedControl.selectedSegmentIndex = selectedIndex
                cell.indexPath = indexPath
                cell.delegate = self
                cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! AlertTextFieldCell
                
                switch alert.type {
                case .price:
                    cell.label.text = "Price"
                    if let value = alert.value {
                        cell.textField.text = "\(value)"
                    } else {
                        cell.textField.text = nil
                    }
                    cell.textField.placeholder = "Price"//"\(stock.trades.last?.price ?? 0.00)"
                    cell.indexPath = indexPath
                    cell.delegate = self
                    break
                default:
                    break
                }
                
                return cell
            default:
                break
            }
            break
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! AlertSwitchCell
                cell.textLabel?.text = "Send Push Notification"
                cell.switchView.setOn(true, animated: false)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! AlertSwitchCell
                cell.textLabel?.text = "Send Email"
                cell.detailTextLabel?.text = "robshanecanton@gmail, replicodechannel@gmail.com"
                return cell
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: "switchCell", for: indexPath) as! AlertSwitchCell
                cell.textLabel?.text = "Send Text Message"
                return cell
            default:
                break
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "resetCell", for: indexPath)
            let resetDelay = ResetDelay(rawValue: alert.reset)!
            cell.textLabel?.text = "Reset"
            cell.detailTextLabel?.text = resetDelay.name
            cell.detailTextLabel?.textColor = UIColor.secondaryLabel
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as! ActionCell
            cell.textLabel?.text = "Save"
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as! ActionCell
            cell.textLabel?.text = "Delete"
            cell.textLabel?.textColor = UIColor.systemRed
            return cell
        default:
            break
            
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let textCell = tableView.cellForRow(at: indexPath) as? AlertTextFieldCell
        textCell?.textField.isUserInteractionEnabled = true
        textCell?.textField.becomeFirstResponder()
        
        switch indexPath.section {
        case 2:
            let vc = ResetSelectViewController(selectedOption: alert.reset)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            break
        case 3:
            handleSave()
            break
        case 4:
            break
        default:
            break
        }
        
    }
}

extension AlertOverlayViewController: SegmentedControlCellDelegate {
    func segmentedControlCell(indexPath: IndexPath, didSelect index: Int) {
        switch indexPath.row {
        case 0:
            alert.type = AlertType(rawValue: Int16(index))!
            let reloadRows = [
                IndexPath(row: 1, section: 0),
                IndexPath(row: 2, section: 0)
            ]
            //tableView.reloadRows(at: reloadRows, with: .automatic)
            break
        case 1:
            switch alert.type {
            case .price:
                
                alert.condtion = index + 1
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
}

extension AlertOverlayViewController: AlertTextFieldCellDelegate {
    func alertTextFieldCell(indexPath: IndexPath, didTextChange text: String?) {
        let value = text != nil ? Double(text!) : nil
        switch indexPath.row {

        case 2:
            switch alert.type {
            case .price:
                alert.value = value
                break
            default:
                break
            }
            break
        default:
            break
        }
    }
}



extension AlertOverlayViewController:ResetSelectDelegate {
    func resetSelect(didSelect option: ResetDelay) {
        alert.reset = option.rawValue
        self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
    }
}
