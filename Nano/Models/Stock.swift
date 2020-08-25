//
//  Stock.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//

import Foundation

protocol StockDelegate:class {
    func stockDidUpdate()
}

class Stock:Codable, MarketItem {
    
    fileprivate(set) var symbol:String
    fileprivate(set) var socketSymbol: String
    fileprivate(set) var details:Details?
    fileprivate(set) var day:Close?
    var trades:[Trade]
    var quotes:[Quote]
    var aggregatesSecond:[AggregateSecond]
    fileprivate(set) var previousClose:Close?
    fileprivate(set) var intraday:AggregateResponse?
    
    func addTrade(_ trade:Trade) {
        self.trades.append(trade)
        if trades.count >= 1000 {
            trades.remove(at: 0)
        }
        
    }
    
    func addQuote(_ quote:Quote) {
        self.quotes.append(quote)
        if quotes.count >= 50 {
            quotes.remove(at: 0)
        }
        
    }
    
    func addAggregateSecond(_ aggregate:AggregateSecond) {
        self.aggregatesSecond.append(aggregate)
    }
    
    func copy(from item: MarketItem) {
        guard let stock = item as? Stock else { return }
        self.socketSymbol = item.socketSymbol
        self.details = stock.details
        self.day = stock.day
        self.trades = stock.trades
        self.quotes = stock.quotes
        self.previousClose = stock.previousClose
        self.intraday = stock.intraday
    }
    
    var displayTrades: [MarketTrade] {
        return trades
    }
    
    var displayLastQuote: MarketQuote? {
        return quotes.last
    }
    
}

extension Stock {
    struct Details:Codable {
        let ceo:String?
        let country:String?
        let description:String?
        let employees:Int?
        let exchange:String?
        let exchangeSymbol:String?
        //let industry:String?
        //let marketcap:Int?
        let shares:Double?
        let name:String?
        //let type:String
        //let updated:String?
        //let url:String?
    }
    
    struct Trade:Codable, Comparable, Equatable, MarketTrade {
        let price:Double
        let exchange:Int
        let size:Int
        let timestamp:TimeInterval
        
        static func < (lhs: Trade, rhs: Trade) -> Bool {
            return lhs.timestamp < rhs.timestamp
        }
        
        var p: Double {
            return price
        }
        
        var s: Double {
            return Double(size)
        }
        
        var t: Double {
            return timestamp
        }
    }
    
    struct Quote:Codable, MarketQuote {
        let askexchange:Int?
        let askprice:Double
        let asksize:Int
        let bidexchange:Int?
        let bidprice:Double
        let bidsize:Int
        let timestamp:TimeInterval
    }
    
    struct Close:Codable {
        let open:Double?
        let close:Double?
        let high:Double?
        let low:Double?
        let volume:Double?
    }
    
    struct AggregateSecond:Codable {
        let v:Int?
        let av:Int?
        let op:Double?
        let vw:Double?
        let o:Double?
        let c:Double?
        let h:Double?
        let l:Double?
        let a:Double?
        let s:TimeInterval?
        let e:TimeInterval?
    }
    
}


struct TickerSearchResponse:Codable {
    let tickers:[Ticker]
}

protocol TickerProtocol {
    var symbol:String { get }
    var displayName:String { get }
    var description:String { get }
}

struct Ticker:Codable, TickerProtocol {
    let symbol:String
    let securityName:String
    let exchange:String
    
    var displayName: String {
        return symbol
    }
    
    var description: String {
        return "\(securityName) [\(exchange)]"
    }
}

struct ForexTicker:Codable, TickerProtocol {
    let ticker: String
    let name: String
    let currency: String
    let attrs:Attributes
    
    struct Attributes:Codable {
        let baseName: String
        let base: String
        let currency: String
        let currencyName: String
    }
    
    var symbol:String {
        return ticker
    }
    
    var displayName: String {
        return "\(attrs.base)\(attrs.currency)"
    }
    
    var description: String {
        return "\(attrs.baseName)/\(attrs.currency)"
    }
}

struct CryptoTicker:Codable, TickerProtocol {
    let ticker: String
    let name: String
    let currency: String
    let attrs:Attributes
    
    struct Attributes:Codable {
        let baseName: String
        let base: String
        let currency: String
        let currencyName: String
    }
    
    var symbol:String {
        return ticker
    }
    
    var displayName: String {
        return "\(attrs.base).X"
    }
    
    var description: String {
        return "\(attrs.baseName)/USD"
    }
}


