//
//  InteractiveDetailVC+UITableViewDelegate.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-06.
//

import Foundation
import UIKit

extension InteractiveDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return nil
        case 1:
            return alerts.count > 0 ? "Alerts" : nil
        case 2:
            return nil//"Positions"
        case 3:
            return nil//"Notes"
        case 4:
            return nil //"News"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return alerts.count
        case 2:
            return 0
        case 3:
            return 0
        case 4:
            return 0//news.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if false {//StoreManager.subscriptionStatus == .free {
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! StatsCell
                    cell.configure(item: item)
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsPreviewCell
                    cell.configure(item: item)
                    //cell.bodyLabel.text = stock.details.description
                    //cell.separatorInset = .zero
                    return cell
                default:
                    break
                }
            } else {
                switch indexPath.row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! StatsCell
                    cell.configure(item: item)
                    //cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsPreviewCell
                    cell.configure(item: item)
                    //cell.bodyLabel.text = stock.details.description
                    return cell
                case 2:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "actionsCell", for: indexPath) as! DetailActionsCell
                    cell.delegate = self
                    cell.configure(item: item)
                    return cell
                default:
                    break
                }
            }
            
        case 1:
            let alert = alerts[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath) as! AlertCell
            cell.backgroundColor = UIColor.systemBackground
            cell.textLabel?.attributedText = alert.attrStringRepresentation
            
            
            cell.imageView?.image = alert.iconImage
            cell.imageView?.tintColor = alert.iconColor
            cell.detailTextLabel?.text = "Active"
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as! CommentsPreviewCell
            //cell.bodyLabel.text = stock.details.description
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
            switch indexPath.row {
            case 0:
                break
            case 1:
                self.presentOverlay(.chat)
                break
            default:
                break
            }
        case 1:
            if indexPath.row == alerts.count {
                self.presentOverlay(.alert)
            } else {
                self.presentOverlay(.alert)
            }
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if StoreManager.subscriptionStatus == .free,
//            indexPath.row == 2 {
//            return UITableView.automaticDimension
//        }
        
        return UITableView.automaticDimension
    }
}
