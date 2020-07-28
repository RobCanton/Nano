//
//  Crypto.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-28.
//

import Foundation

class Crypto:Codable, MarketItem {
    let symbol:String
    let socketSymbol: String
    let details:Details
    var trades:[Trade]
    let day:Day?
    let prevDay:Day?
    
    var displayTrades: [MarketTrade] {
        return trades
    }
    
    var displayLastQuote: MarketQuote? {
        return nil
    }
    
    var name:String {
        return "\(symbol)/USD"
    }
    
    func addTrade(_ trade:Trade) {
        self.trades.append(trade)
        if trades.count >= 500 {
            trades.remove(at: 0)
        }
    }
    
    func copy(from item: MarketItem) {
        
    }
    
    struct Details:Codable {
        let name:String
    }
    
    struct Trade: Codable, MarketTrade {
        let p: Double // price
        let s: Double // size
        let x: Int // exchange
        let c: [Int] // conditions
        let t: Double // timestamp
    }
    
    struct Day:Codable {
        let c: Double
        let h: Double
        let l: Double
        let o: Double
        let v: Double
    }

}

