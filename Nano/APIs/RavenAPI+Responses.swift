//
//  RavenAPI+Responses.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-20.
//

import Foundation


extension RavenAPI {
    
    struct InitialSnapshotResponse:Codable {
        
        let marketStatus:String
        let alerts:[Alert]
        let news:NewsResponse
        let lists:ListsResponse
        let snapshots:SnapshotsResponse?
        
    }
    
    struct SnapshotsResponse:Codable {
        let stocks:[String:Stock]
        let forex:[String:Forex]
        let crypto:[String:Crypto]
    }
    
    struct NewsResponse:Codable {
        let topics:[NewsTopic]
    }
    
    struct ListsResponse:Codable {
        let watchlist:[String]
        let mostActiveStocks:[String]
    }
    
    struct UserAccountResponse:Codable {
        let profile:UserProfileResponse?
        let premium:Bool
        
    }
    
    struct UserProfileResponse:Codable {
        let username:String
    }
}
