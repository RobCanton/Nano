//
//  DetailTradeCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-07.
//

import Foundation
import UIKit

class DetailTradeCell:UITableViewCell {
    
    var timeLabel:UILabel!
    var priceLabel:UILabel!
    var volumeLabel:UILabel!
    var stackRow:UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        stackRow = UIStackView()
        contentView.addSubview(stackRow)
        stackRow.constraintToSuperview(10, 12, 10, 12, ignoreSafeArea: true)
        stackRow.distribution = .fillEqually
        
        timeLabel = UILabel()
        timeLabel.text = "12:30 AM"
        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        timeLabel.textColor = .secondaryLabel
        
        priceLabel = UILabel()
        priceLabel.text = "374.50"
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        priceLabel.textAlignment = .right
        
        volumeLabel = UILabel()
        volumeLabel.text = "374.50"
        volumeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        volumeLabel.textAlignment = .right
        
        stackRow.addArrangedSubview(timeLabel)
        stackRow.addArrangedSubview(priceLabel)
        stackRow.addArrangedSubview(volumeLabel)
        
    }
    
    func defaultHeader() {
        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        volumeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        priceLabel.textColor = UIColor.secondaryLabel
        volumeLabel.textColor = UIColor.secondaryLabel
        timeLabel.text = "Time"
        priceLabel.text = "Price"
        volumeLabel.text = "Size"
    }
    
    func configure(trade:MarketTrade) {
        timeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        priceLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        volumeLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        priceLabel.textColor = UIColor.label
        volumeLabel.textColor = UIColor.label
        
        
        priceLabel.text = "\(trade.p)"
        volumeLabel.text = "\(trade.s)"
        let date = Date(timeIntervalSince1970: trade.t / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm:ss a"
        timeLabel.text = dateFormatter.string(from: date)
    }
}
