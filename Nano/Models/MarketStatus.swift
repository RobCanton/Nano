//
//  MarketStatus.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-21.
//

import Foundation
import UIKit

enum MarketStatus:String {
    case open = "open"
    case closed = "closed"
    case premarket = "pre-market"
    case afterhours = "after-hours"
    
    var displayString:String {
        switch self {
        case .open:
            return "Market Open"
        case .closed:
            return "Market Closed"
        case .premarket:
            return "Pre-market"
        case .afterhours:
            return "After Hours"
        }
    }
    
    var textColor:UIColor {
        switch self {
        case .closed:
            return UIColor.secondaryLabel
        default:
            return UIColor.label
        }
    }
    
    var color:UIColor {
        switch self {
        case .open:
            return Theme.current.positive
        case .closed:
            return UIColor.systemFill
        default:
            return UIColor.systemYellow
        }
    }
}
