//
//  Alert.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//

import Foundation
import UIKit

enum AlertType:Int16 {
    case none = 0
    case price = 1
    case bid = 2
    case ask = 3
    case volume = 4
    
    static let all = [price, bid, ask, volume]
    
    var title:String {
        switch self {
        case .price:
            return "Price"
        case .bid:
            return "Bid"
        case .ask:
            return "Ask"
        case .volume:
            return "Volume"
        default:
            return "None"
        }
    }
    
    
}


enum PriceCondition:Int {
    case isOver = 1
    case isUnder = 2
    
    var stringValue:String {
        switch self {
        case .isOver:
            return "Is Over"
        case .isUnder:
            return "Is Under"
        }
    }
    
    static let all = [.isOver, isUnder]
}


struct Alert:Codable {
    var id: String
    var condition:Int
    var symbol:String
    var type:Int
    var value:Double
    var timestamp: TimeInterval
    var reset:Int
    var enabled:Int
    
    var stringRepresentation:String {
        var str = ""
        let typeStr = AlertType(rawValue: Int16(type))!
        str += typeStr.title
        if condition == 1 {
            str += " is over "
        } else {
            str += " is under "
        }
        str += "\(value)"
        return str
    }
    
    var attrStringRepresentation:NSMutableAttributedString {
        let attr = NSMutableAttributedString()
        
        let typeStr = AlertType(rawValue: Int16(type))!.title
        
        attr.append(NSAttributedString(string: typeStr, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]))
        
        let conditionStr = condition == 1 ? " is over " : " is under "
        attr.append(NSAttributedString(string: conditionStr, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]))
        
        attr.append(NSAttributedString(string: "\(value)", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]))
        
        
        return attr
    }
    
    
    var editable:AlertEditable {
        return AlertEditable(id: id,
                             type: AlertType(rawValue: Int16(type))!,
                             condtion: condition,
                             value: value,
                             reset: reset,
                             enabled: enabled)
    }
    
    var iconImage:UIImage? {
        if condition == 1 {
            return UIImage(systemName: "arrow.up.right")
        } else {
            return UIImage(systemName: "arrow.down.left")
        }
    }
    
    var iconColor:UIColor {
        if condition == 1 {
            return Theme.current.positive
        } else {
            return Theme.current.negative
        }
    }
}

struct AlertEditable {
    var id:String
    var type:AlertType
    var condtion:Int
    var value:Double?
    var reset:Int
    var enabled:Int
    
    var isValid:Bool {
        if value == nil {
            return false
        }
        return true
    }
    
    
}



enum ResetDelay:Int {
    case never = 0
    case oneMinute = 1
    case fiveMinutes = 2
    case fifteenMinutes = 3
    case halfHour = 4
    case oneHour = 5
    case endOfDay = 6
    
    static let all = [oneMinute, fiveMinutes, fifteenMinutes, oneHour, endOfDay, never]
    
    var name:String {
        switch self {
        case .never:
            return "Never"
        case .oneMinute:
            return "After one minute"
        case .fiveMinutes:
            return "After five minutes"
        case .fifteenMinutes:
            return "After fifteen minutes"
        case .halfHour:
            return "After half an hour"
        case .oneHour:
            return "After one hour"
        case .endOfDay:
            return "At end of day"
        }
    }
}
