//
//  ChartView.swift
//  Stockraven
//
//  Created by Robert Canton on 2020-05-15.
//

import Foundation
import UIKit

class ChartView:UIView {
    
    var ticks = [AggregateTick]()
    var startTime:Double = 0
    var endTime:Double = 0
    var tzOffset:Double = 0
    var maxValue:CGFloat = 0
    var minValue:CGFloat = 0
    var guideValue:Double?
    
    var sign = Sign.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.clear
        
        self.clearsContextBeforeDrawing = true
        
        self.transform = CGAffineTransform(scaleX: 1, y: -1)
        
    }
    
    override func draw(_ rect: CGRect) {
        guard ticks.count >= 2 else { return }
        
        let timespan = endTime - startTime
        let spread = maxValue - minValue
        
        if let guideValue = guideValue {
            let guidePath = UIBezierPath()
            
            let guideY = (CGFloat(guideValue)-minValue) / spread * rect.maxY
            guidePath.move(to: CGPoint(x: 0, y: guideY))
            guidePath.addLine(to: CGPoint(x: rect.maxX, y: guideY))
            UIColor.secondaryLabel.set()
            guidePath.lineWidth = 1
            let pattern: [CGFloat] = [2.0, 2.0]
            guidePath.setLineDash(pattern, count: 2, phase: 0.0)
            guidePath.stroke()

        }
        
        let aPath = UIBezierPath()
        
        for i in 0..<ticks.count {
            let tick = ticks[i]
            let tickTime = tick.t/1000-tzOffset
            let timeDiff = tickTime - startTime
            
            let x = CGFloat(timeDiff / timespan) * rect.maxX
            let y = (CGFloat(tick.c)-minValue) / spread * rect.maxY

            if i == 0 {
                aPath.move(to: CGPoint(x: x, y: y))
            } else {
                aPath.addLine(to: CGPoint(x: x, y: y))
            }
            
        }

        
        sign.color.set()
        
        
        aPath.lineWidth = 1
        aPath.stroke()
        
    }
    
    @objc func redraw() {
        self.setNeedsDisplay()
    }
    
    func startLoading() {
        UIView.animate(withDuration: 0.05, animations: {
            self.alpha = 0.0
        })
    }
    
    func displayTicks(_ data:AggregateResponse, sign: Sign, guide:Double?=nil) {
        let ticks = data.results
        guard ticks.count >= 2 else { return }
        
        self.sign = sign
        self.guideValue = guide
        
        startTime = data.start
        endTime = data.end
        tzOffset = data.offset
        
        let startTick = AggregateTick(v: 0,
                                      vw: 0,
                                      o: 0,
                                      c: 0,
                                      h: 0,
                                      l: 0,
                                      t: (startTime + tzOffset)*1000)
        let startIndex = binarySearch(array: ticks, value: startTick, greater: true) ?? 0
        
        let endTick = AggregateTick(v: 0,
                                    vw: 0,
                                    o: 0,
                                    c: 0,
                                    h: 0,
                                    l: 0,
                                    t: (endTime + tzOffset)*1000)
        let endIndex = binarySearch(array: ticks, value: endTick, greater: false) ?? ticks.count - 1
        
        
        self.ticks = Array(ticks[startIndex...endIndex])
        
        var _maxValue:Double = 0
        var _minValue:Double = Double.greatestFiniteMagnitude
        for tick in self.ticks {
            if tick.c > _maxValue {
                _maxValue = tick.c
            }
            if tick.c < _minValue {
                _minValue = tick.c
            }
        }
        
        if guideValue != nil {
            if guideValue! > _maxValue {
                _maxValue = guideValue!
            }
            
            if guideValue! < _minValue {
                _minValue = guideValue!
            }
        }
        
        self.maxValue = CGFloat(_maxValue)
        self.minValue = CGFloat(_minValue)
        
        redraw()
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
            self.alpha = 1.0
        }, completion: nil)
    }
    
    
 
}
