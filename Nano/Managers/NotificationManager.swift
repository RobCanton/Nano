//
//  NotificationManager.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-05.
//

import Foundation
import Firebase
import SwiftMessages

class NotificationManager {
    
    static let shared = NotificationManager()
    
    var alertsRef:DatabaseReference? {
        guard let uid = Auth.auth().currentUser?.uid else { return nil }
        return Database.database().reference(withPath: "app/user/alerts/\(uid)")
    }
    
    var triggeredAlerts = [Alert]()
    private init (){
        
    }
    
    func start() {
        guard let ref = alertsRef else { return }
        self.triggeredAlerts = []
        ref.observeSingleEvent(of: .value, with: { snapshot in
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let childData = childSnapshot.value as? [String:Any],
                    let id = childData["id"] as? String,
                    let condition = childData["condition"] as? Int,
                    let symbol = childData["symbol"] as? String,
                    let type = childData["type"] as? Int,
                    let value = childData["value"] as? Double,
                    let timestamp = childData["timestamp"] as? TimeInterval,
                    let reset = childData["reset"] as? Int,
                    let enabled = childData["enabled"] as? Int{
                    let alert = Alert(id: id, condition: condition, symbol: symbol, type: type, value: value, timestamp: timestamp, reset: reset, enabled: enabled)
                    self.triggeredAlerts.insert(alert, at: 0)
                }
            }
            
            NotificationCenter.post(.triggeredAlertsUpdated)
            self.observe()
        })
        
    }
    
    private func observe() {
        guard let ref = alertsRef else { return }
        var query:DatabaseQuery
        if let lastTimestamp = triggeredAlerts.first?.timestamp {
            query = ref.queryOrdered(byChild: "timestamp").queryStarting(atValue: lastTimestamp)
        } else {
            query = ref
        }
        
        query.observe(.childAdded, with: { snapshot in
            
            if let data = snapshot.value as? [String:Any],
                let id = data["id"] as? String,
                let condition = data["condition"] as? Int,
                let symbol = data["symbol"] as? String,
                let type = data["type"] as? Int,
                let value = data["value"] as? Double,
                let timestamp = data["timestamp"] as? TimeInterval,
                let reset = data["reset"] as? Int,
                let enabled = data["enabled"] as? Int {
                let alert = Alert(id: id, condition: condition, symbol: symbol, type: type, value: value, timestamp: timestamp, reset: reset, enabled: enabled)
                self.triggeredAlerts.insert(alert, at: 0)
                print("Alert added!")
                NotificationCenter.post(.triggeredAlertsUpdated)
                //self.presentAlert(alert: alert)
            }
            
        })
    }
    
    private func presentAlert(alert: Alert) {
        let view: MessageView
        view = MessageView.viewFromNib(layout: .cardView)
        
        view.configureContent(title: alert.symbol,
                              body: alert.stringRepresentation,
                              iconImage: nil,
                              iconText: nil,
                              buttonImage: nil,
                              buttonTitle: nil,
                              buttonTapHandler: { _ in SwiftMessages.hide() })
        view.configureTheme(backgroundColor: UIColor.systemBlue, foregroundColor: .label)
        
        /*view.titleLabel?.textColor = UIColor.label
        view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        view.bodyLabel?.textColor = UIColor.label
        view.bodyLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)*/
//        view.titleLabel?.attributedText = NSAttributedString(string: "TSLA  -  720.45", attributes: [
//             NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .bold)
//        ])
//
        view.button?.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        view.button?.tintColor = UIColor.white
        view.button?.backgroundColor = UIColor.clear
        view.tapHandler = { _ in
            SwiftMessages.hide()
        }
        
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .bottom
        config.presentationContext = .window(windowLevel: .alert)
        config.duration = .seconds(seconds: 5)
        config.interactiveHide = true
        //config.presentationStyle = .custom(animator: <#T##Animator#>)
        
        SwiftMessages.show(config: config, view: view)
    
    }
    
    
}
