//
//  RavenAPI+News.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-15.
//

import Foundation

extension RavenAPI {
    
    static func getNews(forSymbols symbols:[String], completion: @escaping(_ news:[News])->()) {
        let url = "\(getURL(for: .news))/symbols"
        
        struct NewsResponse:Codable {
            let data:[News]
        }
        
        var symbolsStr = ""
        for i in 0..<symbols.count {
            let symbol = symbols[i]
            if i == 0 {
                symbolsStr += "\(symbol)"
            } else {
                symbolsStr += ",\(symbol)"
            }
        }
        let params = [
            "symbols": symbolsStr
        ]
        authenticatedRequest(.get, url: url, params: params) { data, response, error in
            var news = [News]()
            if let data = data {
                do {
                    let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                    news = response.data
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion(news)
            }
        }
    }
    
    static func getMarketNews(completion: @escaping(_ news:[News])->()) {
        let url = "\(getURL(for: .news))/market"
        
        struct NewsResponse:Codable {
            let data:[News]
        }
        
        authenticatedRequest(.get, url: url, cachePolicy: .reloadIgnoringLocalCacheData) { data, response, error in
            var news = [News]()
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)// as? [[String:Any]]
                    
                    let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                    news = response.data
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion(news)
            }
        }
    }
    
    static func getTrendingNews(completion: @escaping(_ news:[News])->()) {
        let url = "\(getURL(for: .news))/trending"
        
        struct NewsResponse:Codable {
            let data:[News]
        }
        
        authenticatedRequest(.get, url: url, cachePolicy: .reloadIgnoringLocalCacheData) { data, response, error in
            var news = [News]()
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)// as? [[String:Any]]
                    
                    let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                    news = response.data
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion(news)
            }
        }
    }
    
    static func getNews(forTopic topic:String, completion: @escaping(_ news:[News])->()) {
        let url = "\(getURL(for: .news))/topic/\(topic)"
        
        struct NewsResponse:Codable {
            let data:[News]
        }
        
        authenticatedRequest(.get, url: url, cachePolicy: .reloadIgnoringLocalCacheData) { data, response, error in
            var news = [News]()
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)// as? [[String:Any]]
                    
                    let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                    news = response.data
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion(news)
            }
        }
    }
    
    static func getNews(forTopic topic:NewsTopic, completion: @escaping(_ news:[News])->()) {        
        let url = "\(getURL(for: .news))/alltickers?\(topic.query)"
        print("GET News: \(url)")
        struct NewsResponse:Codable {
            let data:[News]
        }
        
        authenticatedRequest(.get, url: url, cachePolicy: .reloadIgnoringLocalCacheData) { data, response, error in
            var news = [News]()
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)// as? [[String:Any]]
                    
                    let response = try JSONDecoder().decode(NewsResponse.self, from: data)
                    news = response.data
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion(news)
            }
        }
    }
    
    static func extractArticle(newsURL:URL, completion: @escaping(_ extract:NewsExtract?)->()) {
        let url = "\(getURL(for: .news))/extract"
        let body = [
            "url": newsURL.absoluteString
        ]
        
        authenticatedRequest(.post, url: url, params: nil, body: body, cachePolicy: .reloadIgnoringCacheData)  { data, response, error in
            var extract:NewsExtract?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("JSON: \(json)")
                    let response = try JSONDecoder().decode(NewsExtract.self, from: data)
                    //news = response.data
                    extract = response
                    
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            DispatchQueue.main.async {
                completion(extract)
            }
        }
    }
}
