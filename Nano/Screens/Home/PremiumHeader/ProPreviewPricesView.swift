//
//  ProPreviewPricesView.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-23.
//

import Foundation
import UIKit

class ProPreviewPricesView:UIView {
    var symbolLabel:UILabel!
    var priceLabel:UILabel!
    var item:MarketItem?
    
    private(set) var chartContainer:UIView!
    private(set) var liveChartView:LiveChartMiniView!
    
    var price:Double = 372.45
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        
        self.constraintHeight(to: 44)
        self.constraintWidth(to: UIScreen.main.bounds.width * 0.75)
        
        let contentView = UIView()
        self.addSubview(contentView)
        contentView.constraintToSuperview(0, nil, 0, nil, ignoreSafeArea: true)
        contentView.constraintWidth(to: UIScreen.main.bounds.width * 0.75)
        contentView.constraintToCenter(axis: [.x])
        
        
        let bubble = UIView()
        contentView.addSubview(bubble)
        bubble.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: true)
        bubble.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        bubble.applyShadow(radius: 12.0, opacity: 0.3, offset: CGSize(width: 0, height: 4.0), color: .black, shouldRasterize: false)
        
        symbolLabel = UILabel()
        contentView.addSubview(symbolLabel)
        symbolLabel.constraintToCenter(axis: [.y])
        symbolLabel.constraintToSuperview(nil, 12, nil, nil, ignoreSafeArea: true)
        symbolLabel.text = "AAPL"
        symbolLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        symbolLabel.textColor = .white
        
        priceLabel = UILabel()
        contentView.addSubview(priceLabel)
        priceLabel.constraintToCenter(axis: [.y])
        priceLabel.constraintToSuperview(nil, nil, nil, 12, ignoreSafeArea: true)
        priceLabel.text = "\(price)"
        priceLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        priceLabel.textColor = .white
        
        //let timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(changePrice), userInfo: nil, repeats: true)
        chartContainer = UIView()
        contentView.addSubview(chartContainer)
        chartContainer.constraintToCenter(axis: [.x])
        chartContainer.constraintToSuperview(8, nil, 8, nil, ignoreSafeArea: true)
        chartContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3).isActive = true
        
        liveChartView = LiveChartMiniView()
        chartContainer.addSubview(liveChartView)
        liveChartView.constraintToSuperview()
        
        
        if MarketManager.shared.marketStatus == .open {
            item = MarketManager.shared.items["AAPL"]
        } else {
            item = MarketManager.shared.items["X:BTCUSD"]
        }
        if item != nil {
            NotificationCenter.addObserver(self, selector: #selector(updateTradeDisplay), type: .stockTradeUpdated(item!.symbol))
        }
        
    }
    
    @objc func changePrice() {
        let random = Int.random(in: 0...3)
        if random == 0 { return }
        price += Double.random(in: -0.02...0.02)
        priceLabel.text = String(format: "%.2f", locale: Locale.current, price)
        
    }
    
    @objc func updateTradeDisplay() {
        guard let stock = self.item as? Stock else { return }
        priceLabel?.text = String(format: "%.2f", locale: Locale.current, stock.price)
        liveChartView.displayTrades(stock.trades, lineColor: .white)

    }
}
