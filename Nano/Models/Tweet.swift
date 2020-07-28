//
//  Tweet.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-05.
//

import Foundation


struct Tweet:Codable {
    let id:Int
    let text:String
    let created_at:String
    let user:TwitterUser
    
    var createdAt:Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE MMM dd HH:mm:ss Z yyyy"
        return dateFormatter.date(from: "Tue May 05 19:46:42 +0000 2020")
    }
    
    
    
}

struct TwitterUser:Codable {
    let id:Int
    let name:String
    let screen_name:String
    let profile_image_url_https:String?
    
    var profileImageURL:URL? {
        if let url = profile_image_url_https {
            return URL(string: url)
        }
        return nil
    }
}
