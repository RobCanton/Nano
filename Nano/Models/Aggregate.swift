//
//  AggregateTick.swift
//  Stockraven
//
//  Created by Robert Canton on 2020-05-15.
//

import Foundation

struct AggregateResponse: Codable {
    let ticker: String
    let start:TimeInterval
    let end:TimeInterval
    let offset:TimeInterval
    let results: [AggregateTick]
}

struct AggregateTick:Codable, Comparable, Equatable {
    
    let v: Double
    let vw: Double
    let o: Double
    let c: Double
    let h: Double
    let l: Double
    let t: Double
    
    static func < (lhs: AggregateTick, rhs: AggregateTick) -> Bool {
        return lhs.t < rhs.t
    }
}

enum AggregateTimeframe:String {
    case live = "LIVE"
    case oneDay = "1D"
    case oneWeek = "1W"
    case oneMonth = "1M"
    case threeMonths = "3M"
    case sixMonths = "6M"
    case yearToDate = "YTD"
    case oneYear = "1Y"
    case twoYears = "2Y"
    case fiveYears = "5Y"
    case all = "ALL"

    static let list = [live, oneDay, oneWeek, oneMonth,
                       threeMonths, sixMonths, yearToDate,
                       oneYear, twoYears, fiveYears, all]
    
}
