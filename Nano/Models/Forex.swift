//
//  Forex.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-01.
//

import Foundation

class Forex:Codable, MarketItem {
    let symbol:String
    let socketSymbol: String
    let details:Details
    var quotes:[Quote]
    let prevClose:Day?
    
    var displayTrades: [MarketTrade] {
        return []
    }
    
    var displayLastQuote: MarketQuote? {
        return nil
    }
    
    var name:String {
        return details.name
    }
    
    func addQuote(_ quote:Quote) {
        self.quotes.append(quote)
        if quotes.count >= 500 {
            quotes.remove(at: 0)
        }
    }
    
    func copy(from item: MarketItem) {
        
    }
    
    struct Details:Codable {
        let name:String
    }
    
    struct Quote:Codable {
        let a: Double
        let b: Double
        let x: Int
        let t: Double
    }
    
    struct Day:Codable {
        let c: Double
        let h: Double
        let l: Double
        let o: Double
        let v: Double
        let t: Double
    }

}
