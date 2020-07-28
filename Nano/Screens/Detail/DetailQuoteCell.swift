//
//  DetailTradeCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-14.
//

import Foundation
import UIKit

class DetailQuoteCell:UITableViewCell {
    
    weak var stock:Stock?
    var bidAskView:BidAskView!
    var bidTitleLabel:UILabel!
    var askTitleLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        bidAskView = BidAskView(.default)
        contentView.addSubview(bidAskView)
        bidAskView.constraintToSuperview(nil, 16, 16, 16, ignoreSafeArea: true)
        
        bidTitleLabel = UILabel()
        bidTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        bidTitleLabel.text = "BID"
        contentView.addSubview(bidTitleLabel)
        bidTitleLabel.constraintToSuperview(16, 16, nil, nil, ignoreSafeArea: false)
        
        askTitleLabel = UILabel()
        askTitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        askTitleLabel.text = "ASK"
        contentView.addSubview(askTitleLabel)
        askTitleLabel.constraintToSuperview(16, nil, nil, 16, ignoreSafeArea: false)
        
        bidAskView.topAnchor.constraint(equalTo: bidTitleLabel.bottomAnchor, constant: 8).isActive = true
        bidAskView.bidSizeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        bidAskView.bidPriceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        bidAskView.askSizeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        bidAskView.askPriceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    }
    
    func configure(stock:Stock) {
        self.stock = stock
        updateQuoteDisplay()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.addObserver(self, selector: #selector(updateQuoteDisplay), type: .stockQuoteUpdated(stock.symbol))
    }
    
    @objc func updateQuoteDisplay() {
        guard let stock = self.stock else { return }
        //bidAskView.displayQuote(stock.lastQuote)
    }
    
}
