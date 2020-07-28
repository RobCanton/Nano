//
//  UserProfile.swift
//  Nano
//
//  Created by Robert Canton on 2020-07-26.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation

struct UserProfile {
    let username:String
    let profileImageURL:URL
    
    static func parse(_ data:[String:Any]) -> UserProfile? {
        if let username = data["username"] as? String,
            let _profileImageURL = data["profile_image_url"] as? String,
            let profileImageURL = URL(string: _profileImageURL) {
            
            return UserProfile(username: username, profileImageURL: profileImageURL)
        }
        return nil
    }
}
