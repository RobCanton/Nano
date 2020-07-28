//
//  DetailQuoteCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-07.
//

import Foundation
import UIKit

class DetailQuoteViewCell: UITableViewCell {
    
    var quoteView:QuoteView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        quoteView = QuoteView()
        contentView.addSubview(quoteView)
        quoteView.constraintToSuperview(16,12,16,12,ignoreSafeArea: true)
    }
    
    func configure(item:MarketItem) {
        quoteView.configure(item: item)
    }
    
}

class QuoteView:UIView {
    
    let maxWidth:CGFloat
    weak var item:MarketItem?
    
    var trackView:QuoteTrackView!
    var bidView:UIView!
    var askView:UIView!
    var bidSizeLabel:UILabel!
    var askSizeLabel:UILabel!
    
    init(maxWidth:CGFloat = UIScreen.main.bounds.width) {
        self.maxWidth = maxWidth
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        
        let trackWidth = maxWidth - (24)
        trackView = QuoteTrackView(frame: CGRect(x: 0, y: 0, width: trackWidth, height: 2))
        addSubview(trackView)
        trackView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: true)
        trackView.constraintHeight(to: 2)
        
        bidView = UIView()
        addSubview(bidView)
        bidView.constraintToSuperview(nil, 0, 0, nil, ignoreSafeArea: true)
        bidView.topAnchor.constraint(equalTo: trackView.bottomAnchor, constant: 8).isActive = true
        
        askView = UIView()
        addSubview(askView)
        askView.constraintToSuperview(nil, nil, 0, 0, ignoreSafeArea: true)
        askView.topAnchor.constraint(equalTo: trackView.bottomAnchor, constant: 8).isActive = true
        askView.leadingAnchor.constraint(equalTo: bidView.trailingAnchor).isActive = true
        
        bidView.widthAnchor.constraint(equalTo: askView.widthAnchor).isActive = true
        
        //bidView.backgroundColor = UIColor.systemBlue
        //askView.backgroundColor = UIColor.systemRed
        
        bidSizeLabel = UILabel()
        bidView.addSubview(bidSizeLabel)
        bidSizeLabel.constraintToSuperview(0, 0, 0, nil, ignoreSafeArea: true)
        bidSizeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        askSizeLabel = UILabel()
        askView.addSubview(askSizeLabel)
        askSizeLabel.constraintToSuperview(0, nil, 0, 0, ignoreSafeArea: true)
        askSizeLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        askSizeLabel.textColor = .secondaryLabel
        
    }
    
    func configure(item:MarketItem) {
        self.item = item
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.addObserver(self, selector: #selector(updateQuoteDisplay), type: .stockQuoteUpdated(item.symbol))
        updateQuoteDisplay()
    }
    
    @objc func updateQuoteDisplay() {
        guard let item = self.item else { return }
        
        guard let quote = item.displayLastQuote else { return }
        trackView.configure(leftSize: quote.bidsize, rightSize: quote.asksize)
        bidSizeLabel.text = "\(quote.bidsize)"
        askSizeLabel.text = "\(quote.asksize)"
    }
}

class QuoteTrackView: UIView {
    
    var leftBar:UIView!
    var rightBar:UIView!
    let gap:CGFloat = 2
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        //self.backgroundColor = UIColor.systemBlue
        leftBar = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width/2 - gap, height: bounds.height))
        leftBar.backgroundColor = UIColor.label
        addSubview(leftBar)
        
        rightBar = UIView(frame: CGRect(x: bounds.width/2 + gap, y: 0, width: bounds.width/2 - gap, height: bounds.height))
        rightBar.backgroundColor = UIColor.secondaryLabel
        addSubview(rightBar)
        
    }
    
    func configure(leftSize:Int, rightSize:Int) {
        
        let ratio = CGFloat(leftSize) / (CGFloat(leftSize) + CGFloat(rightSize))
        let bidBarSize = self.bounds.width * ratio
        let askBarSize = self.bounds.width - bidBarSize
        leftBar.frame = CGRect(x: 0, y: 0, width: bidBarSize - gap, height: bounds.height)
        rightBar.frame = CGRect(x: bidBarSize + gap, y: 0, width: askBarSize - gap, height: bounds.height)
    }
}
