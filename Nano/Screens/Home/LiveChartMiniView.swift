//
//  LiveChartView.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-08.
//

import Foundation
import UIKit


class LiveChartMiniView:UIView {
    
    private var baseValue:CGFloat = 10
    private var trailingDiff:CGFloat = 0
    private var positive:Bool = true
    
    private var lineColor:UIColor = UIColor.white
    
    private let timeDenominator:Double = 30000 //milliseconds
    
    var points = [TimePoint(value: 10, timestamp: Date().timeIntervalSince1970)]
    struct TimePoint {
        var value:CGFloat
        var timestamp:Double
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.clear//systemBackground
        
        self.clearsContextBeforeDrawing = true
        
        let timer = Timer(timeInterval: 0.5, target: self, selector: #selector(redraw), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
        
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        //let tap = UITapGestureRecognizer(target: self, action: #selector(addRandomValue))
        //self.addGestureRecognizer(tap)
        //self.isUserInteractionEnabled = true
    }
    
    override func draw(_ rect: CGRect) {
        guard points.count >= 2 else { return }
        let aPath = UIBezierPath()
        
        let frontPointX = rect.maxX * 1.0
        
        let denominator:CGFloat = CGFloat(timeDenominator)

        let now = Date().timeIntervalSince1970 * 1000
        let diff = now - points[0].timestamp
        
        let diffY = points[0].value-baseValue
        let changePercent = diffY / baseValue
        //print("change: \(changePercent)")
        let newY = (rect.maxY * 50) * changePercent
        aPath.move(to: CGPoint(x: (1 - (CGFloat(diff)/denominator)) * frontPointX, y: rect.midY + newY))
        //aPath.move(to: CGPoint(x: 0, y: rect.midY ))
//
        

        for i in 0..<points.count {

            let point = points[i]
            
            let _diff = now - point.timestamp
            let _diffY = point.value-baseValue
            let _changePercent = _diffY / baseValue
            let _newY = (rect.maxY * 50) * _changePercent
            aPath.addLine(to: CGPoint(x: (1 - (CGFloat(_diff)/denominator)) * frontPointX, y: rect.midY + _newY))

        }


        aPath.addLine(to: CGPoint(x: frontPointX, y: rect.midY))
        
        // Keep using the method addLine until you get to the one where about to close the path
        //aPath.close()

        // If you want to stroke it with a red color
        //UIColor.red.set()
        lineColor.set()
        
        aPath.lineWidth = 1
        aPath.stroke()
    }
    
    @objc func redraw() {
        self.setNeedsDisplay()
    }
    
    func displayTrades(_ trades:[Stock.Trade], lineColor:UIColor) {
        guard trades.count > 2 else { return }
        self.lineColor = lineColor
        let now = Date().timeIntervalSince1970 * 10000
        let _trades = trades.filter({ trade in
            return trade.timestamp < now - timeDenominator
        })
        baseValue = CGFloat(_trades.last!.price)
        var _points = [TimePoint]()
        for trade in _trades {
            let point = TimePoint(value: CGFloat(trade.price),
                                  timestamp: trade.timestamp)
            _points.append(point)
        }
        points = _points
        redraw()
    }
    
    func displayQuotes(_ quotes:[Forex.Quote], lineColor:UIColor) {
        guard quotes.count > 2 else { return }
        self.lineColor = lineColor
        let now = Date().timeIntervalSince1970 * 10000
        let _quotes = quotes.filter({ quote in
            return quote.t < now - timeDenominator
        })
        baseValue = CGFloat(_quotes.last!.b)
        var _points = [TimePoint]()
        for quote in _quotes {
            let point = TimePoint(value: CGFloat(quote.b),
                                  timestamp: quote.t)
            _points.append(point)
        }
        points = _points
        redraw()
    }
    
    func displayTrades(_ trades:[Crypto.Trade], lineColor:UIColor) {
        guard trades.count > 2 else { return }
        self.lineColor = lineColor
        let now = Date().timeIntervalSince1970 * 10000
        let _trades = trades.filter({ trade in
            return trade.t < now - timeDenominator
        })
        baseValue = CGFloat(_trades.last!.p)
        var _points = [TimePoint]()
        for trade in _trades {
            let point = TimePoint(value: CGFloat(trade.p),
                                  timestamp: trade.t)
            _points.append(point)
        }
        points = _points
        redraw()
    }
    
}
