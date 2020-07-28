//
//  RavenAPI+Search.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-24.
//

import Foundation


extension RavenAPI {
    
    static func search(_ text:String, completion: @escaping ((_ searchFragment:String, _ tickers:[Ticker])->())) {
        
        if text.isEmpty {
            completion(text, [])
            return
        }
        
        let url = "\(getURL(for: .searchStocks))/\(text)"
        
        authenticatedRequest(.get, url: url, cachePolicy: .returnCacheDataElseLoad) { data, response, error in
            var tickers = [Ticker]()
            
            if let data = data {
                do {
                    tickers = try JSONDecoder().decode([Ticker].self, from: data)

                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion(text, tickers)
            }
        }
    }
    
    static func searchForex(_ text:String, completion: @escaping ((_ searchFragment:String, _ tickers:[ForexTicker])->())) {
        
        if text.isEmpty {
            completion(text, [])
            return
        }
    
        let url = "\(getURL(for: .searchForex))/\(text)"
        
        authenticatedRequest(.get, url: url, cachePolicy: .returnCacheDataElseLoad) { data, response, error in
            var tickers = [ForexTicker]()
            
            if let data = data {
                do {
                    tickers = try JSONDecoder().decode([ForexTicker].self, from: data)
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion(text, tickers)
            }
        }
    }
    
    static func searchCrypto(_ text:String, completion: @escaping ((_ searchFragment:String, _ tickers:[CryptoTicker])->())) {
        
        if text.isEmpty {
            completion(text, [])
            return
        }

        
        
        let url = "\(getURL(for: .searchCrypto))/\(text)"
        
        authenticatedRequest(.get, url: url, cachePolicy: .returnCacheDataElseLoad) { data, response, error in
            var tickers = [CryptoTicker]()
            
            if let data = data {
                do {
                    tickers = try JSONDecoder().decode([CryptoTicker].self, from: data)
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion(text, tickers)
            }
        }
    }
    
}
