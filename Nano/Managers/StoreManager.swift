//
//  StoreManager.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-22.
//

import Foundation
import StoreKit

enum UserSubscriptionStatus {
    case free
    case premium
}

enum Product:String {
    case premiumMonthly = "premium_44f7"
}

class StoreManager: NSObject {
    
    
    static let all_products:[Product] = [
        .premiumMonthly
    ]
    
    var products = [String:SKProduct]()
    
    static let shared = StoreManager()
    
    static var subscriptionStatus = UserSubscriptionStatus.free
    
    private override init() {
        
    }
    
    func fetchProducts() {
        let map = StoreManager.all_products.map { productID in
            return productID.rawValue
        }
        let productIDs = Set(map)
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
    
    func purchase(productID:String) {
        if let product = products[productID] {
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
}

extension StoreManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        response.invalidProductIdentifiers.forEach { product in
            print("Invalid: \(product)")
        }
        
        response.products.forEach { product in
            print("Valid: \(product)")
            products[product.productIdentifier] = product
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
}
