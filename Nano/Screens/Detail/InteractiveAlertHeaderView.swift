//
//  InteractiveAlertHeaderView.swift
//  Stockraven
//
//  Created by Robert Canton on 2020-05-17.
//

import Foundation
import UIKit

class InteractiveAlertHeaderView:UIView {
    weak var stock:Stock?
    var priceLabel:UILabel!
    let startingValue:Double
    let stepSize:Double
    var baseValue:Double
    var chartView:ChartView!
    
    
    init (frame:CGRect, stock:Stock) {
        self.stock = stock
        self.startingValue = stock.trades.last?.price ?? 0
        if startingValue < 10 {
            stepSize = 0.01
        } else if startingValue < 100 {
            stepSize = 0.1
        } else if startingValue < 1000 {
            stepSize = 1
        } else {
            stepSize = 10
        }
        self.baseValue = startingValue
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        chartView = ChartView()
        self.addSubview(chartView)
        chartView.constraintToSuperview(16, 0, nil, 0, ignoreSafeArea: true)
        chartView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.5).isActive = true
        
        
        
        if let stock = self.stock, let intraday = stock.intraday {
            self.chartView.displayTicks(intraday, sign: stock.sign)
        }
        
        self.backgroundColor = UIColor.clear
        priceLabel = UILabel()
        self.addSubview(priceLabel)
        priceLabel.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
        priceLabel.topAnchor.constraint(equalTo: chartView.bottomAnchor).isActive = true
        priceLabel.textAlignment = .center
        priceLabel.font = UIFont.monospacedSystemFont(ofSize: 32, weight: .bold)
        priceLabel.text = "\(baseValue)"
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(pan)
    }
    
    var startPoint:CGPoint?
    var changeValue:CGFloat?
    var refValue:Double = 0
    
    @objc func handlePan(_ pan:UIPanGestureRecognizer) {
        let touchPoint = pan.location(in: self)
        
        switch pan.state {
        case .began:
            startPoint = touchPoint;
            refValue = baseValue
            break
        case .ended:
            startPoint = nil
            break
        case .changed:
            guard let start = startPoint else { return }
            let diffX = (touchPoint.x - start.x) / self.bounds.maxX
            
            //print("diffX: \(diffX)")
            let diffY = (self.bounds.maxY - touchPoint.y) / self.bounds.maxY

            let diffRounded = round(100*diffX/2)
            
            //print("v: \(v) \(diffYRounded)")
            var ss = stepSize
           
            if diffY > 0.15 {
                ss = stepSize / 10
            }
            baseValue = refValue + Double(diffRounded) * ss
            priceLabel.text = String(format:"%.02f", baseValue)
//
//            let diffY = (touchPoint.y - start.y) / self.bounds.maxY
//
//
//            let v = (diffRounded) * 0.01
//            print("\(diffRounded) | \(v)")
//            baseValue = baseValue + Double(v)
//            priceLabel.text = String(format:"%.02f", baseValue)
            break
        default:
            break
        }
 
        
//        let diffRounded = round(100*diff)
//
//        print("diffRounded: \(diffRounded)")
//        let v = diffRounded * 0.05
////        let v = Double(diff) * startingValue/4
////
////        let vrounded = round(100.0 * v) / 100.0
//        baseValue = startingValue + Double(v)
//        priceLabel.text = String(format:"%.02f", baseValue)
        
    }
}
