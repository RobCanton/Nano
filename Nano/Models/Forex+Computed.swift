//
//  Forex+Computed.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-01.
//

import Foundation
import UIKit

extension Forex {
    
    var price:Double {
        return quotes.last?.b ?? 0
    }
    
    var change:Double? {
        if let prevClose = prevClose?.c {
            return price - prevClose
        }
        return nil
    }
    
    var changePercent:Double? {
        if let change = change,
            let prevClose = prevClose?.c {
            let changePercent = abs(change / prevClose) * 100
            
            return changePercent
        }
        return nil
    }
    
    var changeStr:String? {
        guard let change = change else { return nil }
        let formatted = NumberFormatter.localizedString(from: NSNumber(value: change),
                                                        number: NumberFormatter.Style.decimal)
        if change > 0 {
            return "+\(formatted)"
        }
        
        return formatted
    }
    
    var changePercentStr:String? {
        guard let changePercent = changePercent else { return nil }
        return "\(String(format: "%.2f", locale: Locale.current, changePercent))%"
    }
    
    var changePercentSignedStr:String? {
        guard let change = change, let changePercent = self.changePercent else { return nil }
        
        let str = "\(String(format: "%.2f", locale: Locale.current, changePercent))%"
        if change > 0 {
            return "+\(str)"
        } else if change < 0 {
            return "-\(str)"
        } else {
            return str
        }
    }
    
    var changeCompositeStr:String {
        guard let change = changeStr, let changePercent = changePercentStr else { return "" }
        
        return "\(change) (\(changePercent))"
    }
    
    var changeColor:UIColor {
        guard let change = change else { return UIColor.label }
        if change > 0 {
            return UIColor(hex: "33E190")
        } else if change < 0 {
            return UIColor(hex: "FF3860")
        } else {
            return UIColor.label
        }
    }
    
    var stats:[StatValue] {
        var _stats = [StatValue]()
        for statType in StatType.forex {
            var value:String = "-"
            switch statType {
            case .prevClose:
                if let prevClose = self.prevClose?.c {
                    value = "\(prevClose)"
                }
                break
            default:
                value = "N/A"
                break
            }
            _stats.append(StatValue(type: statType,
                                    value: value))
        }
        return _stats
    }
    
}
