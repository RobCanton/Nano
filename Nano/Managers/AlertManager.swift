//
//  AlertManager.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-21.
//

import Foundation

class AlertManager {
    
    static let shared = AlertManager()
    
    private(set) var alerts = [Alert]()
    private(set) var alertIndexes = [String:[Int]]()
    
    func alerts(for symbol:String) -> [Alert] {
        var _alerts = [Alert]()
        if let indexes = alertIndexes[symbol] {
            for i in indexes {
                _alerts.append(alerts[i])
            }
        }
        _alerts.sort(by: { return $0.timestamp < $1.timestamp })
        return _alerts
    }
    
    private init() {
        
    }
    
    func configure(alerts:[Alert]) {
        self.alerts = alerts
        
        for i in 0..<alerts.count {
            let alert = alerts[i]
            if alertIndexes[alert.symbol] == nil {
                alertIndexes[alert.symbol] = [i]
            } else {
                alertIndexes[alert.symbol]!.append(i)
            }
        }
    }
    
    func addAlert(_ alert:Alert) {
        let index = alerts.count
        self.alerts.append(alert)
        
        if self.alertIndexes[alert.symbol] == nil {
            self.alertIndexes[alert.symbol] = [index]
        } else {
            self.alertIndexes[alert.symbol]!.append(index)
        }
        
        NotificationCenter.post(.alertsUpdated)
    }
    
    func updateAlert(_ alert:Alert) {
        guard let index = alerts.firstIndex(where: { $0.id == alert.id }) else { return }
        alerts[index] = alert
        
        NotificationCenter.post(.alertsUpdated)
    }
    
    func deleteAlert(withID id:String, completion: @escaping ()->()) {
        RavenAPI.deleteAlert(id) {
            completion()
        }
    }
    
}
