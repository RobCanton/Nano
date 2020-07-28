//
//  MarketItem.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-30.
//

import Foundation

enum MarketType:String {
    case stocks = "stocks"
    case forex = "forex"
    case crypto = "crypto"
}

protocol MarketItem:class {
    var symbol:String { get }
    var socketSymbol:String { get }
    var name:String { get }
    
    var price:Double { get }
    
    var stats:[StatValue] { get }
    
    var displayTrades:[MarketTrade] { get }
    
    var displayLastQuote:MarketQuote? { get }
    
    func copy(from item:MarketItem)
}

struct Item:Codable {
    let symbol:String
    let marketType:String
}

enum StatType:String {
    case open = "Open"
    case low = "Low"
    case high = "High"
    case volume = "Volume"
    case marketCap = "Mkt Cap"
    case prevClose = "Prev Close"
    case close = "Close"
    
    static let all = [open, low, high, volume, marketCap, prevClose, close]
    static let forex = [open, low, high, volume, prevClose]
    static let crypto = [open, low, high, volume]
}

struct StatValue {
    let type:StatType
    let value:String
}


protocol MarketTrade {
    var p:Double { get }
    var s:Double { get }
    var t:TimeInterval { get }
}

protocol MarketQuote {
    var bidprice:Double { get }
    var bidsize:Int { get }
    var askprice:Double { get }
    var asksize:Int { get }
}
