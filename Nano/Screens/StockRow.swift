//
//  StockRow.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-19.
//

import Foundation
import UIKit


class StockRow:UIView {
    
    weak var stock:Stock?
    weak var item:MarketItem?
    
    private(set) var titleRow:UIView!
    private(set) var symbolLabel:UILabel!
    private(set) var nameLabel:UILabel!
    private(set) var priceLabel:UILabel!
    private(set) var changeLabel:UILabel!
    private(set) var chartContainer:UIView!
    private(set) var liveChartView:LiveChartMiniView!
    private(set) var chartView:ChartView!
    private(set) var bidAskView:BidAskView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        titleRow = UIView()
        self.addSubview(titleRow)
        titleRow.constraintToSuperview(12, 12, 12, 12, ignoreSafeArea: true)
        
        symbolLabel = UILabel()
        symbolLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleRow.addSubview(symbolLabel)
        symbolLabel.constraintToSuperview(0, 0, nil, nil, ignoreSafeArea: true)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        nameLabel.textColor = .secondaryLabel
        titleRow.addSubview(nameLabel)
        nameLabel.constraintToSuperview(nil, 0, 0, nil, ignoreSafeArea: true)
        nameLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 3).isActive = true
        
        priceLabel = UILabel()
        priceLabel.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .bold)
        priceLabel.textAlignment = .right
        titleRow.addSubview(priceLabel)
        priceLabel.constraintToSuperview(nil, nil, nil, 0, ignoreSafeArea: false)
        priceLabel.lastBaselineAnchor.constraint(equalTo: symbolLabel.lastBaselineAnchor).isActive = true
        
        changeLabel = UILabel()
        changeLabel.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        changeLabel.textAlignment = .right
        titleRow.addSubview(changeLabel)
        changeLabel.constraintToSuperview(nil, nil, 0, 0, ignoreSafeArea: false)
        changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 3).isActive = true
        
        //nameLabel.lastBaselineAnchor.constraint(equalTo: changeLabel.lastBaselineAnchor).isActive = true
        
        chartContainer = UIView()
        titleRow.addSubview(chartContainer)
        chartContainer.constraintToCenter(axis: [.x])
        chartContainer.constraintToSuperview(8, nil, 8, nil, ignoreSafeArea: true)
        chartContainer.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.2).isActive = true
        
        liveChartView = LiveChartMiniView()
        chartContainer.addSubview(liveChartView)
        liveChartView.constraintToSuperview()
        
        chartView = ChartView()
        chartContainer.addSubview(chartView)
        chartView.constraintToSuperview()
        chartView.isHidden = true
        
        symbolLabel.trailingAnchor.constraint(equalTo: chartContainer.leadingAnchor, constant: -8).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: chartContainer.leadingAnchor, constant: -8).isActive = true
        
        priceLabel.leadingAnchor.constraint(equalTo: chartContainer.trailingAnchor, constant: 8).isActive = true
        changeLabel.leadingAnchor.constraint(equalTo: chartContainer.trailingAnchor, constant: 8).isActive = true
        
        
//        if StoreManager.subscriptionStatus == .premium {
//            bidAskView = BidAskView(.compact)
//            self.addSubview(bidAskView!)
//            bidAskView!.constraintToSuperview(nil, 16, 16, 16, ignoreSafeArea: true)
//            bidAskView!.topAnchor.constraint(equalTo: titleRow.bottomAnchor, constant: 12).isActive = true
//        } else {
//            titleRow.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
//        }
        
        
    }
    
    func configure(item:MarketItem) {
        self.item = item
  
        NotificationCenter.default.removeObserver(self)
        if let forex = item as? Forex {
            NotificationCenter.addObserver(self, selector: #selector(updateTradeDisplay), type: .stockTradeUpdated(forex.symbol))
        } else if let crypto = item as? Crypto {
            NotificationCenter.addObserver(self, selector: #selector(updateTradeDisplay), type: .stockTradeUpdated(crypto.symbol))
        } else {
            NotificationCenter.addObserver(self, selector: #selector(updateTradeDisplay), type: .stockTradeUpdated(item.symbol))
            NotificationCenter.addObserver(self, selector: #selector(updateQuoteDisplay), type: .stockQuoteUpdated(item.symbol))
            //NotificationCenter.addObserver(self, selector: #selector(updateAggregateDisplay), type: .stockAggregateSecondUpdated(item.symbol))
        }
        updateDisplay()
    }

    
    @objc private func updateDisplay() {
        //guard let stock = self.stock else { return }
        guard let item = self.item else { return }
        symbolLabel.text = item.symbol
        nameLabel.text = item.name
        
        updateTradeDisplay()
        updateQuoteDisplay()
    }
    
    @objc private func updateAggregateDisplay() {
        if let stock = self.item as? Stock {
            priceLabel?.text = String(format: "%.2f", locale: Locale.current, stock.aggregatesSecond.last?.c ?? 0)
            changeLabel?.text = stock.changeCompositeStr
            changeLabel?.textColor = stock.changeColor
            
//            if MarketManager.shared.marketStatus == .closed,
//                let intraday = stock.intraday {
//                chartView.isHidden = false
//                liveChartView.isHidden = true
//                chartView.displayTicks(intraday, sign: stock.sign)
//            } else {
//                chartView.isHidden = true
//                liveChartView.isHidden = false
//                liveChartView.displayTrades(stock.trades, positive: (stock.change ?? 0) >= 0)
//            }
        }
    }
    @objc private func updateTradeDisplay() {
        if let stock = self.item as? Stock {
            priceLabel?.text = String(format: "%.2f", locale: Locale.current, stock.price)
            changeLabel?.text = stock.changeCompositeStr
            let changeColor = stock.changeColor
            changeLabel?.textColor = changeColor
            
            if MarketManager.shared.marketStatus == .closed,
                let intraday = stock.intraday {
                chartView.isHidden = false
                liveChartView.isHidden = true
                chartView.displayTicks(intraday, sign: stock.sign)
            } else {
                chartView.isHidden = true
                liveChartView.isHidden = false
                
                liveChartView.displayTrades(stock.trades, lineColor: changeColor)
            }
        } else if let forex = self.item as? Forex {
            priceLabel?.text = String(format: "%.4f",
                                      locale: Locale.current,
                                      forex.price)
            changeLabel?.text = forex.changeCompositeStr
            let changeColor = forex.changeColor
            changeLabel?.textColor = changeColor
            
            chartView.isHidden = true
            liveChartView.isHidden = false
            liveChartView.displayQuotes(forex.quotes, lineColor: changeColor)
        } else if let crypto = self.item as? Crypto {
            
            let lastTrade = crypto.price
            
            priceLabel?.text = String(format: "%.2f",
                                      locale: Locale.current,
                                      lastTrade)
            changeLabel?.text = crypto.changeCompositeStr
            let changeColor = crypto.changeColor
            changeLabel?.textColor = changeColor
            
            chartView.isHidden = true
            liveChartView.isHidden = false
            liveChartView.displayTrades(crypto.trades, lineColor: changeColor)
            /*
            if crypto.trades.count > 1 {
                let prevTrade = crypto.trades[crypto.trades.count-2].p
                if lastTrade > prevTrade {
                    priceLabel.textColor = Theme.current.positive
                } else if lastTrade < prevTrade {
                    priceLabel.textColor = Theme.current.negative
                } else {
                    priceLabel.textColor = UIColor.label
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
                    UIView.transition(with: self.priceLabel, duration: 0.35, options: .transitionCrossDissolve, animations: {
                        self.priceLabel.textColor = UIColor.label
                    }, completion: nil)
                })
                

            }
            */
            
        }
    }
    
    @objc private func updateQuoteDisplay() {
        guard let stock = self.item as? Stock else { return }
        //bidAskView?.displayQuote(stock.lastQuote)
    }
    
}

extension StockRow: StockDelegate {
    func stockDidUpdate() {
        updateDisplay()
    }
}
