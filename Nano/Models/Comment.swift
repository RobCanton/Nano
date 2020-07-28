//
//  Comment.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-04.
//

import Foundation


struct Comment {
    let uid:String
    let profile:UserProfile
    let dateCreated:Date
    let roomID:String
    let text:String
    
    static func parse(_ data:[String:Any]) -> Comment? {
        if let uid = data["uid"] as? String,
            let profileData = data["profile"] as? [String:Any],
            let profile = UserProfile.parse(profileData),
            let roomID = data["roomID"] as? String,
            let text = data["text"] as? String,
            let _dateCreated = data["dateCreated"] as? Double {
            
            let dateCreated = Date(timeIntervalSince1970: _dateCreated / 1000)
            
            return Comment(uid: uid,
                           profile: profile,
                           dateCreated: dateCreated,
                           roomID: roomID,
                           text: text)
        }
        
        return nil
    }
    
}
