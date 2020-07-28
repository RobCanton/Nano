//
//  HeaderDisplayView.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-18.
//

import Foundation
import UIKit
import Lottie

class HeaderDisplayView:UIView {
    
    var item:MarketItem
    var backgroundView:UIView!
    private(set) var controlsDisplay:UIView!
    private(set) var closeButton:UIButton!
    
    private(set) var bidAskView:BidAskView?
    private(set) var liveChartView:LiveChartView!
    private(set) var chartView:ChartView!
    
    private(set) var stockRow:StockRow!
    
    init(item:MarketItem) {
        self.item = item
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        self.backgroundColor = UIColor(hex: "171717")
        self.clipsToBounds = true
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemMaterial))
        self.addSubview(blurView)
        blurView.constraintToSuperview()
        blurView.isHidden = true
        
        backgroundView = UIView()
        self.addSubview(backgroundView)
        backgroundView.constraintToSuperview()
        backgroundView.backgroundColor = UIColor.black
        
        stockRow = StockRow()
        self.addSubview(stockRow)
        stockRow.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
        stockRow.configure(item: item)
        stockRow.chartContainer.alpha = 0.0
        
        
        let chartContentView = UIView()
        self.addSubview(chartContentView)
        chartContentView.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: false)
        chartContentView.bottomAnchor.constraint(equalTo: stockRow.topAnchor, constant: -12).isActive = true
        chartContentView.constraintHeight(to: Constants.headerDisplayHeight - 64 - 12 - 12)
        
        liveChartView = LiveChartView()
        chartContentView.addSubview(liveChartView)
        liveChartView.constraintToSuperview()
        
        chartView = ChartView()
        chartContentView.addSubview(chartView)
        chartView.constraintToSuperview()
        chartView.isHidden = true
        
        controlsDisplay = UIView()
        self.addSubview(controlsDisplay)
        controlsDisplay.constraintToSuperview()
        
        closeButton = UIButton(type: .system)
//        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
//        closeButton.tintColor = UIColor.white
//        controlsDisplay.addSubview(closeButton)
//        closeButton.constraintToSuperview(4, 8, nil, nil, ignoreSafeArea: false)
//        
//        closeButton.constraintWidth(to: 44)
//        closeButton.constraintHeight(to: 44)
    
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.addObserver(self, selector: #selector(updateTradeDisplay), type: .stockTradeUpdated(item.symbol))
        NotificationCenter.addObserver(self, selector: #selector(updateQuoteDisplay), type: .stockQuoteUpdated(item.symbol))
        updateDisplay()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func handleTap() {
        self.toggleControls(self.controlsDisplay.alpha != 0.0)
    }
    
    func toggleControls(_ hidden:Bool) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            if hidden {
                self.controlsDisplay.alpha = 0.0
            } else {
                self.controlsDisplay.alpha = 1.0
            }
        }, completion: nil)
    }
    
    @objc private func updateDisplay() {
        updateTradeDisplay()
        updateQuoteDisplay()
    }
    
    @objc private func updateTradeDisplay() {
        
        if let stock = item as? Stock {
            if MarketManager.shared.marketStatus == .closed,
                let intraday = stock.intraday {
                chartView.isHidden = false
                liveChartView.isHidden = true
                RavenAPI.getAggregatePreset(for: stock.symbol, timeframe: .oneDay) { timeframe, response in
                    guard let response = response else { return }
                    self.chartView.displayTicks(response,
                                                sign: stock.sign,
                                                guide: stock.previousClose?.close)
                }

            } else {
                chartView.isHidden = true
                liveChartView.isHidden = false
                liveChartView.displayTrades(stock.trades, positive: (stock.change ?? 0) >= 0)
            }
        } else if let forex = item as? Forex {
            //
        } else if let crypto = item as? Crypto {
            chartView.isHidden = true
            liveChartView.isHidden = false
            //liveChartView.displayTrades(crypto.trades, positive: (crypto.change ?? 0) >= 0)
        }
        
    }
    
    @objc private func updateQuoteDisplay() {
        //bidAskView?.displayQuote(stock.lastQuote)
    }
    
    func updateTransition(progress:CGFloat) {
        let alpha = pow(progress, 5)
        liveChartView.alpha = alpha
        chartView.alpha = alpha
        stockRow.chartContainer.alpha = 1 - progress
        
        backgroundView.alpha = progress
    }
}
