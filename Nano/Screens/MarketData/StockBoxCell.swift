//
//  StockBoxCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-17.
//

import Foundation
import UIKit

class StockBoxCell:UICollectionViewCell {
    
    weak var stock:Stock?
    
    var symbolLabel:UILabel!
    var priceLabel:UILabel!
    var changeLabel:UILabel!
    var liveChartView:LiveChartMiniView!
    var chartView:ChartView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        contentView.backgroundColor = UIColor(white: 0.09, alpha: 1.0)
        //contentView.layer.borderColor = UIColor.separator.cgColor
        //contentView.layer.borderWidth = 1.0
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        
        symbolLabel = UILabel()
        contentView.addSubview(symbolLabel)
        symbolLabel.constraintToSuperview(12, 12, nil, nil, ignoreSafeArea: true)
        symbolLabel.text = "ATVI"
        symbolLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        
        priceLabel = UILabel()
        contentView.addSubview(priceLabel)
        priceLabel.constraintToSuperview(nil, 12, nil, nil, ignoreSafeArea: true)
        priceLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 4).isActive = true
        priceLabel.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .light)
        priceLabel.text = "75.45"
        
        changeLabel = UILabel()
        contentView.addSubview(changeLabel)
        changeLabel.constraintToSuperview(nil, 12, 12, 12, ignoreSafeArea: true)
        changeLabel.textColor = Theme.current.positive
        changeLabel.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .regular)
        changeLabel.text = "+1.38%"
        changeLabel.textAlignment = .left
        //changeLabel.constraintWidth(to: width)
        
        let chartContainer = UIView()
        contentView.addSubview(chartContainer)
        chartContainer.constraintToSuperview(nil, 12, nil, 12, ignoreSafeArea: true)
        chartContainer.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 12).isActive = true
        chartContainer.bottomAnchor.constraint(equalTo: changeLabel.topAnchor, constant: -12).isActive = true
        
        liveChartView = LiveChartMiniView()
        chartContainer.addSubview(liveChartView)
        liveChartView.constraintToSuperview()
        
        chartView = ChartView()
        chartContainer.addSubview(chartView)
        chartView.constraintToSuperview()
        chartView.isHidden = true
        
    }
    
    func configure(stock:Stock) {
        self.stock = stock
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.addObserver(self, selector: #selector(updateTradeDisplay), type: .stockTradeUpdated(stock.symbol))
        //NotificationCenter.addObserver(self, selector: #selector(updateQuoteDisplay), type: .stockQuoteUpdated(stock.symbol))
        updateDisplay()
    }
    
    @objc private func updateDisplay() {
        guard let stock = self.stock else { return }
        symbolLabel.text = stock.symbol
        
        updateTradeDisplay()
        //updateQuoteDisplay()
    }
    
    @objc private func updateTradeDisplay() {
        guard let stock = self.stock else { return }
        priceLabel?.text = String(format: "%.2f", locale: Locale.current, stock.trades.last?.price ?? 0)
        changeLabel?.text = stock.changePercentSignedStr
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
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                contentView.backgroundColor = UIColor(white: 0.18, alpha: 1.0)
            } else {
                UIView.animate(withDuration: 0.45, delay: 0.0, options: .curveEaseOut, animations: {
                    self.contentView.backgroundColor = UIColor(white: 0.09, alpha: 1.0)
                })
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                contentView.backgroundColor = UIColor(white: 0.18, alpha: 1.0)
            } else {
                UIView.animate(withDuration: 0.45, delay: 0.0, options: .curveEaseOut, animations: {
                    self.contentView.backgroundColor = UIColor(white: 0.09, alpha: 1.0)
                })
            }
        }
    }
}
