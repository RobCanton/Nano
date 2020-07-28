//
//  Stock+Computed.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-01.
//

import Foundation
import UIKit

extension Stock {
    var name:String {
        return details?.name ?? ""
    }

    
    var sign:Sign {
        if let price = trades.last?.price,
            let previousClose = previousClose?.close {
            if price > previousClose {
                return .positive
            } else if price < previousClose {
                return .negative
            }
            return .zero
        }
        return .zero
    }
    
    var price:Double {
        return trades.last?.price ?? 0
    }
    
    var change:Double? {
        if let price = trades.last?.price,
            let previousClose = previousClose?.close {
            return price - previousClose
        }
        return nil
    }
    
    var changePercent:Double? {
        if let change = change,
            let previousClose = previousClose?.close {
            let changePercent = abs(change / previousClose) * 100
            
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
        for statType in StatType.all {
            var value:String = "-"
            switch statType {
            case .open:
                if let open = day?.open {
                    value = "\(open)"
                }
                break
            case .low:
                if let low = day?.low {
                    value = "\(low)"
                }
                break
            case .high:
                if let high = day?.high {
                    value = "\(high)"
                }
                break
            case .volume:
                if let volume = day?.volume {
                    value = volume.shortFormatted
                }
                break
            case .marketCap:
                if let shares = details?.shares, let price = trades.last?.price {
                    let marketCap = shares * price
                    value = marketCap.shortFormatted
                }
                break
            case .prevClose:
                if let prevClose = previousClose?.close {
                    value = "\(prevClose)"
                }
                break
            case .close:
                if let close = day?.close {
                    value = "\(close)"
                }
            }
            _stats.append(StatValue(type: statType,
                                    value: value))
        }
        return _stats
    }
}
