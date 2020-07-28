//
//  Notification+Extensions.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//


import Foundation


extension NotificationCenter {
    enum NotificationType {
        
        case stocksUpdated
        case stockTradeUpdated(_ symbol:String)
        case stockQuoteUpdated(_ symbol:String)
        case stockAggregateSecondUpdated(_ symbol:String)
        case marketStatusUpdated
        case screenChanged
        case action(_ screen:Screen, _ action:Action)
        case alertsUpdated
        case triggeredAlertsUpdated
        case showSideMenu
        case pinStock
        case unpinStock
        
        var id:String {
            switch self {
            case .stocksUpdated:
                return "stocks-updated"
            case let .stockTradeUpdated(symbol):
                return "T.\(symbol)"
            case let .stockQuoteUpdated(symbol):
                return "Q.\(symbol)"
            case let .stockAggregateSecondUpdated(symbol):
                return "A.\(symbol)"
            case .marketStatusUpdated:
                return "market-status-updated"
            case .screenChanged:
                return "screen-changed"
            case let .action(screen, action):
                return "action-\(screen.rawValue)-\(action.rawValue)"
            case .alertsUpdated:
                return "alerts-updated"
            case .triggeredAlertsUpdated:
                return "triggered-alerts-updated"
            case .showSideMenu:
                return "show-side-menu"
            case .pinStock:
                return "pin-stock"
            case .unpinStock:
                return "unpin-stock"
            }
        }
        
        var name:Notification.Name {
            return Notification.Name(id)
        }
        
    }
    
    
    static func post(_ type:NotificationType, userInfo: [AnyHashable : Any]?=nil) {
        self.default.post(name: type.name, object: nil, userInfo: userInfo)
    }
    
    static func addObserver(_ observer:NSObject, selector: Selector, type: NotificationCenter.NotificationType) {
        self.default.addObserver(observer, selector: selector, name: type.name, object: nil)
    }
    
    static func removeObserver(_ observer:NSObject, type: NotificationCenter.NotificationType) {
        self.default.removeObserver(observer, name: type.name, object: nil)
    }
    
}

extension Notification.Name {
    
}
