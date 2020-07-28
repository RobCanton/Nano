//
//  RavenAPI.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//

import Foundation
import Firebase

enum HTTPMethod:String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

class RavenAPI {

    static let shared = RavenAPI()
    
    static let host = "http://raven.replicode.io/"
    
    enum Endpoint:String {
        case watchlist = "user/watchlist"
        case searchStocks = "ref/search/stocks"
        case searchForex = "ref/search/forex"
        case searchCrypto = "ref/search/crypto"
        case registerPushToken = "user/pushtoken"
        case stockHistoricTrades = "stocks/trades"
        case userAccount = "user/account"
        case userAlerts = "user/alerts"
        case socialTwitterSearch = "social/twitter/search"
        case refNews = "ref/news"
        case refStockAggregates = "ref/stocks/aggs/"
        case refStockAggregatePreset = "ref/stocks/aggregate/preset"
        case news = "news"
        case market = "market"
        
    }
    
    static func getURL(for endpoint:Endpoint) -> String {
        return "\(RavenAPI.host)\(endpoint.rawValue)"
    }
    
    static private let session = URLSession.shared
    
    static var authToken:String? {
        didSet {
            if authToken != nil {
                print("AuthToken: \(authToken!)")
            }
        }
    }
    static var pushToken:String?

    private init() {
    
    }
    
    struct WatchlistResponse:Codable {
        let marketStatus:String
        let stocks:[Stock]
        let alerts:[Alert]
        let newsTopics:[NewsTopic]
        let mostActiveStocks:[Stock]
    }
    
//    struct DynamicWatchlistResponse:Codable {
//        let stocks:[DynamicStock]
//    }
//
    
    static func getInitialSnapshot(completion: @escaping (_ result:InitialSnapshotResponse)->()) {

        let url = getURL(for: .watchlist)
        
        authenticatedRequest(.get, url: url) { data, response, error in
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("JSON: \(json)")
                    let result = try JSONDecoder().decode(InitialSnapshotResponse.self, from: data)
                    
                    DispatchQueue.main.async {
                        completion(result)
                    }
                    
                } catch {
                    
                    /// TODO: Handle fail
                }
            } else {
                /// TODO: Handle fail
            }
        }
    }
    
    static func getWatchlist(completion: @escaping ((_ marketStatus:String?, _ items:[Stock], _ alerts:[Alert], _ newsTopics:[NewsTopic], _ mostActiveStocks:[Stock])->())) {
        let url = getURL(for: .watchlist)
         
        authenticatedRequest(.get, url: url) { data, response, error in
            var marketStatus:String?
            var stocks = [Stock]()
            var alerts = [Alert]()
            var newsTopics = [NewsTopic]()
            var mostActiveStocks = [Stock]()
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    let resp = try JSONDecoder().decode(WatchlistResponse.self, from: data)
                    stocks = resp.stocks
                    alerts = resp.alerts
                    marketStatus = resp.marketStatus
                    newsTopics = resp.newsTopics
                    mostActiveStocks = resp.mostActiveStocks
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }

            DispatchQueue.main.async {
                completion(marketStatus, stocks, alerts, newsTopics, mostActiveStocks)
            }
        }
    }
    
    static func patchWatchlist(_ symbols:[String]) {
        let url = "\(getURL(for: .watchlist))"
        
        var arrayStr = ""
        for i in 0..<symbols.count {
            let symbol = symbols[i]
            if i == 0 {
                arrayStr += symbol
            } else {
                arrayStr += ",\(symbol)"
            }
        }
        let params:[String:Any] = [
            "symbols": arrayStr
        ]
        authenticatedRequest(.patch, url: url, params: params) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("patchWatchlist: \(json)")
                    
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }

        }
    }
    
    static func subscribe(to ticker:String, completion: @escaping ((_ item:MarketItem?)->())) {
        let url = "\(getURL(for: .watchlist))/\(ticker)"
        
        authenticatedRequest(.post, url: url) { data, response, error in
            var item:MarketItem?
            if let data = data {
                do {
                    let marketItem = try JSONDecoder().decode(Item.self, from: data)
                    
                    switch marketItem.marketType {
                    case MarketType.stocks.rawValue:
                        item = try JSONDecoder().decode(Stock.self, from: data)
                        break
                    case MarketType.forex.rawValue:
                        item = try JSONDecoder().decode(Forex.self, from: data)
                        break
                    case MarketType.crypto.rawValue:
                        item = try JSONDecoder().decode(Crypto.self, from: data)
                        break
                    default:
                        break
                    }
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
        
            DispatchQueue.main.async {
                completion(item)
            }
        }
    }
    
    static func unsubscribe(from ticker:String, completion: @escaping (()->())) {
        let url = "\(getURL(for: .watchlist))/\(ticker)"

        
        authenticatedRequest(.delete, url: url) { data, response, error in
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    static func registerPushToken() {
        guard let token = pushToken else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let url = "\(getURL(for: .registerPushToken))/\(token)"
        
        
        let ref = Firestore.firestore().collection("deviceTokens").document(token)
        ref.setData(["uid": uid])
        authenticatedRequest(.post, url: url) { data, response, error in
            print("Error: \(error?.localizedDescription)")

        }
    }
    
    static func stockHistoricTrades(symbol:String, date:String, completion: @escaping ((_ trades:[HistoricTrade])->())) {
        let url = "\(getURL(for: .stockHistoricTrades))/\(symbol)/\(date)"
        
        authenticatedRequest(.get, url: url, cachePolicy: .returnCacheDataElseLoad) { data, response, error in
            var trades = [HistoricTrade]()
            if let data =  data {
                do {
                    trades = try JSONDecoder().decode([HistoricTrade].self, from: data)
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion(trades)
            }
            
        }
    }
    
    static func createAlert(_ alert:AlertEditable, for item:MarketItem, completion: @escaping (_ alert:Alert?)->()) {
        let url = getURL(for: .userAlerts)
        let params:[String:Any] = [
            "symbol": item.symbol,
            "type": alert.type.rawValue,
            "condition": alert.condtion,
            "value": alert.value!,
            "enabled": true,
            "reset": alert.reset
        ]
        print("Params: \(params)")
        authenticatedRequest(.post, url: url, params: params, cachePolicy: .reloadIgnoringCacheData) { data, response, error in
            
            var alert:Alert?
            print("Error: \(error?.localizedDescription)")
            
            if let data = data{
                
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                    print("JSON: \(json)")

                    alert = try JSONDecoder().decode(Alert.self, from: data)

                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            
            DispatchQueue.main.async {
                completion(alert)
            }
            
        }
        
    }
    
    static func patchAlert(_ alert:AlertEditable, completion: @escaping (_ alert:Alert?)->()) {
        let url = "\(getURL(for: .userAlerts))/\(alert.id)"
        let params:[String:Any] = [
            "type": alert.type.rawValue,
            "condition": alert.condtion,
            "value": alert.value!,
            "enabled": alert.enabled,
            "reset": alert.reset
        ]
        
        authenticatedRequest(.patch, url: url, params: params, cachePolicy: .reloadIgnoringCacheData) { data, response, error in
            
            var alert:Alert?
            print("Error: \(error?.localizedDescription)")
            
            if let data = data{
                
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                    print("JSON: \(json)")

                    alert = try JSONDecoder().decode(Alert.self, from: data)

                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            
            DispatchQueue.main.async {
                completion(alert)
            }
            
        }
        
    }
    
    static func deleteAlert(_ id:String, completion: @escaping()->()) {
        let url = "\(getURL(for: .userAlerts))/\(id)"
        
        authenticatedRequest(.delete, url: url) { data, response, error in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                    print("JSON: \(json)")

                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    
    // SOCIAL
    
    static func searchTwitter(_ query:String, completion: @escaping(_ tweets:[Tweet])->()) {
        let url = getURL(for: .socialTwitterSearch)
        
        let params = [
            "query": query
        ]
        authenticatedRequest(.get, url: url, params: params) { data, response, error in
            var tweets = [Tweet]()
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String:Any]]
                    tweets = try JSONDecoder().decode([Tweet].self, from: data)
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion(tweets)
            }
        }
    }
    
    
    static func authenticatedRequest(_ method:HTTPMethod,
                                             url:String,
                                             params:[String:Any]? = nil,
                                             body:[String:Any]?=nil,
                                             cachePolicy:URLRequest.CachePolicy = URLRequest.CachePolicy.reloadIgnoringCacheData,
                                             completion: @escaping ((_ data:Data?, _ response:HTTPURLResponse?, _ error:Error?)->())) {
        
        guard let token = authToken else {
            completion(nil, nil, NSError(domain: "Token missing", code: 401, userInfo: nil))
            return
        }
        
        var urlComponents = URLComponents(string: url)
        
        
        if let params = params {
            var queryItems = [URLQueryItem]()
            for (key, value) in params  {
                let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                queryItems.append(URLQueryItem(name: key, value: encodedValue))
            }
            urlComponents?.queryItems = queryItems
        }
        
        var httpBody:Data?
        if let body = body{
            
            do {
                httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completion(nil, nil, NSError(domain: "Invalid body", code: 402, userInfo: nil))
                return
            }
            
        }
        
        guard let url = urlComponents?.url else {
            completion(nil, nil, nil)
            return
        }
        
        var urlRequest = URLRequest(url: url,
                                    cachePolicy: cachePolicy,
                                    timeoutInterval: 30)
        
        urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        urlRequest.httpBody = httpBody
        
        print("httpBody: \(httpBody)")
        
        print("urlRequest: \(urlRequest)")
        
        let task = session.dataTask(with: urlRequest) { data, response, error in
            completion(data, response as? HTTPURLResponse, error)
        }
        
        
        
        task.resume()
        
    }

    
}

struct HistoricTrade:Codable {
    var close:Double?
    var average:Double?
}
