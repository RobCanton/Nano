//
//  Sign.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-14.
//

import Foundation
import UIKit

enum Sign {
    case positive
    case negative
    case zero
    
    var color:UIColor {
        switch self {
        case .positive:
            return Theme.current.positive
        case .negative:
            return Theme.current.negative
        case .zero:
            return UIColor(white: 0.5, alpha: 1.0)
        }
    }
    
}
