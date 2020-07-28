//
//  NewsManager.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-21.
//

import Foundation

class NewsManager {
    
    static let shared = NewsManager()
    
    var topics:[NewsTopic]
    
    private init() {
        topics = []
    }
    
    func configure(topics:[NewsTopic]) {
        self.topics = topics
    }
    
}
