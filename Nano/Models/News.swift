//
//  News.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-05.
//

import Foundation

struct News:Codable {
    let title:String
    let text:String
    let news_url:String?
    let image_url:String?
    let source_name:String?
    let date: String?
    let topics:[String]?
    let sentiment: String?
    let type:String?
    let tickers:[String]?
    
    var imageURL:URL? {
        if let urlStr = image_url,
            let url = URL(string: urlStr) {
            return url
        }
        return nil
    }
    
    var newsURL:URL? {
        if let urlStr = news_url,
            let url = URL(string: urlStr) {
            return url
        }
        return nil
    }
    
    var dateObject:Date? {
        if let date = date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E, dd MMM yyyy HH:mm:ss Z"
            return dateFormatter.date(from: date)
        }
        return nil
    }
}

struct NewsExtract:Codable {
    struct Article:Codable {
        let articleBody:String
        let headline:String
        let description:String
        let author:String
        let mainImage:String?
    }
    
    let article:Article
}

struct NewsTopic:Codable {
    let name:String
    let query:String
}

