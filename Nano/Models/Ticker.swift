//
//  Ticker.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-20.
//

import Foundation

enum TickerSymbol {
    case stock(_ symbol:String)
    case forex(_ symbol:String)
    case crypto(_ symbol:String)
}
