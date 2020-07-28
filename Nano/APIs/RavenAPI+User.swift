//
//  RavenAPI+User.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-21.
//

import Foundation

extension RavenAPI {
    static func userAccount(completion: @escaping(_ response:UserAccountResponse?)->()) {
        let url = "\(getURL(for: .userAccount))"
        
        authenticatedRequest(.get, url: url, cachePolicy: .reloadIgnoringCacheData)  { data, response, error in
            var response:UserAccountResponse?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("JSON: \(json)")
                    response = try JSONDecoder().decode(UserAccountResponse.self, from: data)
                    
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            DispatchQueue.main.async {
                completion(response)
            }
        }
    }
    
}
