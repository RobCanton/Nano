//
//  RavenAPI+MarketData.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-17.
//

import Foundation

extension RavenAPI {
    

    
    static func getMarketData(completion: @escaping(_ mostActiveStocks:[Stock])->()) {
        let url = getURL(for: .market)
        
        struct MarketDataResponse:Codable {
            let lists:MarketDataListsResponse
        }
        
        struct MarketDataListsResponse:Codable {
            let mostActiveStocks:[Stock]
        }
       
        authenticatedRequest(.get, url: url) { data, response, error in
            var mostActiveStocks = [Stock]()
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print("JSON: \(json)")
                    let response = try JSONDecoder().decode(MarketDataResponse.self, from: data)
                    mostActiveStocks = response.lists.mostActiveStocks
                    
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            
            DispatchQueue.main.async {
                completion(mostActiveStocks)
            }
        }
    }
    
}
