//
//  DetailHeaderCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-14.
//

import Foundation
import UIKit

class DetailHeaderCell:UITableViewCell {
    
    weak var stock:Stock?
    
    private var nameLabel:UILabel!
    private var priceLabel:UILabel!
    private var changeLabel:UILabel!
    private var timeLabel:UILabel!
    private var chartView:MultiChartView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.selectionStyle = .none
        nameLabel = UILabel()
//        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
//        nameLabel.textColor = UIColor.label
//        contentView.addSubview(nameLabel)
//        nameLabel.constraintToSuperview(16, 16, nil, 16, ignoreSafeArea: false)
        
        priceLabel = UILabel()
//        priceLabel.font = UIFont.systemFont(ofSize: 40, weight: .bold)
//        //priceLabel.textAlignment = .right
//        contentView.addSubview(priceLabel)
//        priceLabel.constraintToSuperview(nil, 16, nil, 16, ignoreSafeArea: false)
//        priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16.0).isActive = true
        
        changeLabel = UILabel()
//        changeLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
//        //changeLabel.textAlignment = .right
//        contentView.addSubview(changeLabel)
//        changeLabel.constraintToSuperview(nil, 16, nil, 16, ignoreSafeArea: false)
//        changeLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 0).isActive = true
        
        timeLabel = UILabel()
//        timeLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
//        timeLabel.textColor = .secondaryLabel
//        contentView.addSubview(timeLabel)
//        timeLabel.constraintToSuperview(nil, 16, nil, 16, ignoreSafeArea: false)
//        timeLabel.topAnchor.constraint(equalTo: changeLabel.bottomAnchor, constant: 0).isActive = true
        
        
        chartView = MultiChartView()
        contentView.addSubview(chartView)
        chartView.constraintToSuperview(16, 16, 16, 16, ignoreSafeArea: false)
        //chartView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 16).isActive = true
        chartView.constraintHeight(to: 128 + 32)
        
    }
    
    func configure(stock:Stock) {
        self.stock = stock
        nameLabel.text = stock.details?.name
        timeLabel.text = "11:41 AM"
        chartView.configure(stock)
        
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.addObserver(self, selector: #selector(updateTradeDisplay), type: .stockTradeUpdated(stock.symbol))
        NotificationCenter.addObserver(self, selector: #selector(updateQuoteDisplay), type: .stockQuoteUpdated(stock.symbol))
        
        updateTradeDisplay()
        updateQuoteDisplay()
    }
    
    @objc private func updateTradeDisplay() {
        guard let stock = self.stock else { return }
        priceLabel?.text = String(format: "%.2f", locale: Locale.current, stock.trades.last?.price ?? 0)
        changeLabel?.text = stock.changeCompositeStr
        changeLabel?.textColor = stock.changeColor
        //chartView.displayTrades(stock.trades, positive: stock.change ?? 0 >= 0)
    }
    
    @objc private func updateQuoteDisplay() {
        guard let stock = self.stock else { return }
        //bidAskView.displayQuote(stock.lastQuote)
    }
    
}
