//
//  File.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//

import Foundation
import UIKit

extension UIFont {
    
    
    
    enum FontType {
        case normal
        case condensed
        case monospaced
    }
   
    static func customFont(_ type:FontType = .normal, ofSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch type {
        case .normal:
            switch weight {
            case .thin:
                return UIFont(name: "Roboto-Thin", size: size)!
            case .light:
                return UIFont(name: "Roboto-Light", size: size)!
            case .medium:
                return UIFont(name: "Roboto-Medium", size: size)!
            case .bold:
                return UIFont(name: "Roboto-Bold", size: size)!
            case .black:
                return UIFont(name: "Roboto-Black", size: size)!
            default:
                return UIFont(name: "Roboto-Regular", size: size)!
            }
        case .condensed:
            switch weight {
            case .bold:
                return UIFont(name: "RobotoCondensed-Bold", size: size)!
                case .light:
                return UIFont(name: "RobotoCondensed-Light", size: size)!
            default:
                return UIFont(name: "RobotoCondensed-Regular", size: size)!
            }
        case .monospaced:
            switch weight {
            case .bold:
                return UIFont(name: "RobotoCondensed-Bold", size: size)!
                case .light:
                return UIFont(name: "RobotoCondensed-Light", size: size)!
            default:
                return UIFont(name: "RobotoCondensed-Regular", size: size)!
            }
        }
        
        return UIFont.systemFont(ofSize: size, weight: weight)
    }
    
    
}
