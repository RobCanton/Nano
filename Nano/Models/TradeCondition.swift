//
//  Condition.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-07.
//

import Foundation

enum TradeCondition:Int {
    case regularSale = 0
    case acquisition = 1
    case averagePriceTrade = 2
    case automaticExecution = 3
    case bunchedTrade = 4
    case bunchedSoldTrade = 5
    case cashSale = 7
    case closingPrints = 8
    case crossTrade = 9
    case derivativelyPriced = 10
    case distribution = 11
    case formT = 12
    case extendedTradingHours = 13
    case intermarketSweep = 14
    case marketCenterOfficialClose = 15
     
    
}
