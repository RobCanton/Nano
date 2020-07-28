//
//  MarketManager.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-20.
//

import Foundation
import Firebase

enum List {
    case watchlist
    case mostActiveStocks
}

enum Viewer:String {
    case detail
    case pinbar
    case news
}

struct Lists {
    fileprivate(set) var watchlist:[String]
    fileprivate(set) var mostActiveStocks:[String]
    var viewing:[String:[String]]
    
    init() {
        watchlist = []
        mostActiveStocks = []
        viewing = [:]
    }
    
    init(watchlist:[String], mostActiveStocks:[String]) {
        self.watchlist = watchlist
        self.mostActiveStocks = mostActiveStocks
        self.viewing = [:]
    }
    
    init (_ response:RavenAPI.ListsResponse) {
        self.watchlist = response.watchlist
        self.mostActiveStocks = response.mostActiveStocks
        self.viewing = [:]
    }
    
    func contains(symbol:String) -> Bool {
        
        if viewing[symbol] != nil {
            return true
        }
        
        if watchlist.contains(symbol) {
            return true
        }
        
        if mostActiveStocks.contains(symbol) {
            return true
        }
        
        return false
    }
    
    mutating func addViewer(_ viewer:Viewer, to symbol:String) {
        if viewing[symbol] == nil {
            viewing[symbol] = [viewer.rawValue]
        } else {
            viewing[symbol]!.append(viewer.rawValue)
        }
    }
    
    mutating func removeViewer(_ viewer:Viewer, from symbol:String) {
        if viewing[symbol] != nil {
            viewing[symbol]!.removeAll(where: { str in
                return str == viewer.rawValue
            })
        }
    }
}

class MarketManager {
    
    static let shared = MarketManager()
    
    private var stocksDict = [String:Stock]()
    private var cryptoDict = [String:Crypto]()
    
    var lists:Lists
    
    var items = [String:MarketItem]()
    
    
    var watchlistItems:[MarketItem] {
        var _items = [MarketItem]()
        for symbol in lists.watchlist {
            if let item = items[symbol] {
                _items.append(item)
            }
        }
        return _items
    }
    
    var mostActiveStocksListItems:[MarketItem] {
        var _items = [MarketItem]()
        for symbol in lists.mostActiveStocks {
            if let item = items[symbol] {
                _items.append(item)
            }
        }
        return _items
    }
    
    private(set) var marketStatus = MarketStatus.closed
    
    private init() {
        lists = Lists()
    }
    
    func configure(marketStatus _marketStatus:String,
                   items:[String:MarketItem],
                   lists:Lists) {
        if let marketStatus = MarketStatus(rawValue: _marketStatus) {
            self.marketStatus = marketStatus
        }
        
        
        self.items = items
        //self.stocksDict = stocks
        
        self.lists = lists
        
        RavenSocketManager.shared.connect {
            self.listenToMarketStatusEvents()
                              
            for (_, item) in self.items {
               self.listenToSocketEvents(for: item)
            }
        }
        
//        listenToMarketStatusEvents()
//
//        for (symbol, _) in stocksDict {
//            listenToSocketEvents(for: .stock(symbol))
//        }
        
    }
    
    func listenToMarketStatusEvents() {
        RavenSocketManager.shared.on(event: .marketStatus) { data, ack in
            guard let statusStr = data.first as? String else { return }
            guard let status = MarketStatus(rawValue: statusStr) else { return }
            self.marketStatus = status
            NotificationCenter.post(.marketStatusUpdated, userInfo: ["status": status])
        }
    }
    
    func listenToSocketEvents(for item:MarketItem) {
        guard let token = RavenAPI.authToken else { return }
        
        let symbol = item.symbol
        let socketSymbol = item.socketSymbol
        //RavenSocketManager.shared.emit(event: .join, with: [symbol])
        if let _ = item as? Stock {
            RavenSocketManager.shared.emit(event: .join, with: [socketSymbol, token])
            RavenSocketManager.shared.on(event: .stockTrade( socketSymbol)) { data, ack in
                guard let dict = data.first as? [String:Any] else { return }
                guard let stock = self.items[symbol] as? Stock else { return }
                guard let price = dict["p"] as? Double,
                    let exchange = dict["x"] as? Int,
                    let size = dict["s"] as? Int,
                    let timestamp = dict["t"] as? TimeInterval else { return }
                
                let trade = Stock.Trade(price: price,
                                        exchange: exchange,
                                        size: size,
                                        timestamp: timestamp)
                stock.addTrade(trade)
                
                NotificationCenter.post(.stockTradeUpdated(symbol))
                
            }
            
            RavenSocketManager.shared.on(event: .stockQuote(socketSymbol)) { data, ack in
                guard let dict = data.first as? [String:Any] else { return }
                guard let stock = self.items[symbol] as? Stock else { return }
                guard let askprice = dict["ap"] as? Double,
                    let asksize = dict["as"] as? Int,
                    let bidprice = dict["bp"] as? Double,
                    let bidsize = dict["bs"] as? Int,
                    let timestamp = dict["t"] as? TimeInterval else { return }
                let quote = Stock.Quote(askexchange: nil,
                                        askprice: askprice,
                                        asksize: asksize,
                                        bidexchange: nil,
                                        bidprice: bidprice,
                                        bidsize: bidsize,
                                        timestamp: timestamp)
                
                stock.addQuote(quote)
                
                NotificationCenter.post(.stockQuoteUpdated(symbol))
            }
            
            RavenSocketManager.shared.on(event: .stockAggregatePerSecond(socketSymbol)) { data, ack in
                guard let dict = data.first as? [String:Any] else { return }
                guard let stock = self.items[symbol] as? Stock else { return }
                
                let v = dict["v"] as? Int
                let av = dict["av"] as? Int
                let op = dict["op"] as? Double
                let vw = dict["vw"] as? Double
                let o = dict["o"] as? Double
                let c = dict["c"] as? Double
                let h = dict["h"] as? Double
                let l = dict["l"] as? Double
                let a = dict["a"] as? Double
                let s = dict["s"] as? TimeInterval
                let e = dict["e"] as? TimeInterval
                
                let aggregate = Stock.AggregateSecond(v: v, av: av, op: op, vw: vw, o: o, c: c, h: h, l: l, a: a, s: s, e: e)
                stock.addAggregateSecond(aggregate)
                NotificationCenter.post(.stockAggregateSecondUpdated(symbol))
            }
        } else if let _ = item as? Forex {
            RavenSocketManager.shared.emit(event: .join, with: [socketSymbol, token])
            RavenSocketManager.shared.on(event: .forexQuote(socketSymbol)) { data, ack in
                guard let dict = data.first as? [String:Any] else { return }
                guard let ask = dict["a"] as? Double,
                    let bid = dict["b"] as? Double,
                    let exchange = dict["x"] as? Int,
                    let timestamp = dict["t"] as? Double else { return }
                let quote = Forex.Quote(a: ask, b: bid, x: exchange, t: timestamp)
                if let forex = self.items[symbol] as? Forex {
                    forex.addQuote(quote)
                    
                    NotificationCenter.post(.stockTradeUpdated(symbol))
                }
            }
        } else if let _ = item as? Crypto {
            RavenSocketManager.shared.emit(event: .join, with: [socketSymbol, token])
            RavenSocketManager.shared.on(event: .cryptoTrade(socketSymbol)) { data, ack in
                guard let dict = data.first as? [String:Any] else { return }
                guard let price = dict["p"] as? Double, let size = dict["s"] as? Double,
                    let exchange = dict["x"] as? Int, let conditions = dict["c"] as? [Int],
                    let timestamp = dict["t"] as? Double else { return }
                
                let trade = Crypto.Trade(p: price,
                                         s: size,
                                         x: exchange,
                                         c: conditions,
                                         t: timestamp)
                if let crypto = self.items[symbol] as? Crypto {
                    crypto.addTrade(trade)
                    
                    NotificationCenter.post(.stockTradeUpdated(symbol))
                }
            }
        }
    }
    
    func stopListeningToSocketEvents(for item:MarketItem) {
        let socketSymbol = item.socketSymbol
        if let _ = item as? Stock {
            RavenSocketManager.shared.off(event: .stockTrade(socketSymbol))
            RavenSocketManager.shared.off(event: .stockQuote(socketSymbol))
            RavenSocketManager.shared.off(event: .stockAggregatePerSecond(socketSymbol))
            RavenSocketManager.shared.off(event: .stockAggregatePerMinute(socketSymbol))
            RavenSocketManager.shared.emit(event: .leave, with: [socketSymbol])
        } else if let _ = item as? Forex {
            
        } else if let _ = item as? Crypto {
            RavenSocketManager.shared.off(event: .cryptoTrade(socketSymbol))
        }
        
        RavenSocketManager.shared.emit(event: .leave, with: [socketSymbol])
    }
    
    func toggleSubscription(to symbol:String) {
        if lists.watchlist.contains(symbol) {
            unsubscribe(from: symbol)
        } else {
            subscribe(to: symbol)
        }
    }
    func subscribe(to symbol:String) {
        RavenAPI.subscribe(to: symbol) { item in
            guard let item = item else { return }
            if self.items[item.symbol] == nil {
                self.items[item.symbol] = item
            } else {
                self.items[item.symbol]!.copy(from: item)
            }
            
            if !self.lists.watchlist.contains(item.symbol) {
                self.lists.watchlist.append(item.symbol)
            }
            self.listenToSocketEvents(for: item)
            NotificationCenter.post(.stocksUpdated)
        }
    }
    
    func unsubscribe(from symbol:String) {
        if let item = items[symbol] {
            stopListeningToSocketEvents(for: item)
        }
        
        lists.watchlist.removeAll(where: { _symbol in
            return symbol == _symbol
        })
        
        if !lists.contains(symbol: symbol) {
            if let item = items[symbol] {
                stopListeningToSocketEvents(for: item)
                items[symbol] = nil
            }
        }
        
        NotificationCenter.post(.stocksUpdated)
        
        RavenAPI.unsubscribe(from: symbol) {
            
        }
    }
    
    func moveStock(at sourceIndex: Int, to destinationIndex: Int) {
        
        let moveItem = lists.watchlist.remove(at: sourceIndex)
        lists.watchlist.insert(moveItem, at: destinationIndex)
        
        RavenAPI.patchWatchlist(lists.watchlist)
        
    }
    
}

