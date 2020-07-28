//
//  ThemeManager.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//

import Foundation
import UIKit


enum Theme:String {
    case basicBlue = "basic-blue"
    case basicIndigo = "basic-indigo"
    case basicPink = "basic-pink"
    case basicTeal = "basic-teal"
    case basicYellow = "basic-yellow"
    
    var primary:UIColor {
        return UIColor(named: "\(self.rawValue):primary")!
    }
    
    var secondary:UIColor {
        return UIColor(named: "\(self.rawValue):secondary")!
    }
    
    var positive:UIColor {
        return UIColor(named: "basic:positive")!
    }
    
    var negative:UIColor {
        return UIColor(named: "basic:negative")!
    }
    
    
    static var current = Theme.basicBlue
    static let all:[Theme] = [
        .basicBlue, .basicPink, .basicIndigo, .basicTeal, .basicYellow
    ]
    
    var displayName:String {
        switch self {
        case .basicBlue:
            return "Blue"
        case .basicIndigo:
            return "Indigo"
        case .basicPink:
            return "Pink"
        case .basicTeal:
            return "Teal"
        case .basicYellow:
            return "Yellow"
        }
    }
}
