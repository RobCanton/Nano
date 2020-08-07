//
//  ProPreviewBidAskView.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-24.
//

import Foundation
import UIKit

class ProPreviewBidAskView:UIView {
    
    var item:MarketItem?
    var quoteView:QuoteView!
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
        let maxWidth = UIScreen.main.bounds.width * 0.75
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
        
        
        quoteView = QuoteView(maxWidth: maxWidth)
        contentView.addSubview(quoteView)
        quoteView.constraintToSuperview(nil, 12, nil, 12, ignoreSafeArea: true)
        quoteView.constraintToCenter(axis: [.y])
        quoteView.trackView.rightBar.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        quoteView.askSizeLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        quoteView.trackView.leftBar.backgroundColor = .white
        quoteView.bidSizeLabel.textColor = .white
        
        
        if MarketManager.shared.marketStatus == .open {
            item = MarketManager.shared.items["AAPL"]
        } else {
            item = MarketManager.shared.items["X:BTCUSD"]
        }
        
        if item != nil {
            quoteView.configure(item: item!)
        }
        
    }
    
}
