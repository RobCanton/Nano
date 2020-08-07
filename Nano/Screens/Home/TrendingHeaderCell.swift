//
//  TrendingHeaderCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-23.
//


import Foundation
import UIKit

class TrendingHeaderCell:UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var closeButton:UIButton!
    var collectionView:UICollectionView!
    
    var isScrolling = false
    var speed:CGFloat = 0.25
    
    var items:[MarketItem] = []
    
    struct IndexPair {
        let symbol:String
        let change:String
    }

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .opaqueSeparator
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let width = UIScreen.main.bounds.width / 3
        layout.itemSize = CGSize(width: width, height: 64)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        contentView.addSubview(collectionView)
        collectionView.constraintToSuperview()
        collectionView.constraintHeight(to: 64)
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
//        let timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(nextTick), userInfo: nil, repeats: true)
//        RunLoop.current.add(timer, forMode: .common)
        
        let divider = UIView()
        contentView.addSubview(divider)
        divider.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
        divider.constraintHeight(to: 0.5)
        divider.backgroundColor = .separator
        
        
    }
    
    func configure() {
        items = MarketManager.shared.mostActiveStocksListItems
        
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
        collectionView.reloadData()
    }
    
    @objc func nextTick() {
        if isScrolling { return }
        let offsetX = collectionView.contentOffset.x
        let nextOffsetX = offsetX + 4
        collectionView.contentOffset = CGPoint(x: nextOffsetX, y: 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrendingCell
        let item = items[indexPath.row]
        cell.configure(item: item)
        return cell
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        isScrolling = true
//    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrolling = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isScrolling = false
    }
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        isScrolling = false
//    }
}

class TrendingCell:UICollectionViewCell {
    
    
    weak var item:MarketItem?
    
    var symbolLabel:UILabel!
    var priceLabel:UILabel!
    var changeLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        symbolLabel = UILabel()
        symbolLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        contentView.addSubview(symbolLabel)
        symbolLabel.constraintToSuperview(12, 12, nil, nil, ignoreSafeArea: true)
        //stackView.addArrangedSubview(symbolLabel)
        
        priceLabel = UILabel()
        priceLabel.font = UIFont.monospacedSystemFont(ofSize: 14.0, weight: .semibold)
        contentView.addSubview(priceLabel)
        priceLabel.constraintToSuperview(12, nil, nil, 12, ignoreSafeArea: true)
        priceLabel.text = "265.83"
        
        changeLabel = UILabel()
        changeLabel.font = UIFont.monospacedSystemFont(ofSize: 14.0, weight: .medium)//systemFont(ofSize: 14.0, weight: .medium)
        changeLabel.textColor = Theme.current.negative
        contentView.addSubview(changeLabel)
        changeLabel.constraintToSuperview(nil, 12, 12, 12, ignoreSafeArea: true)
        changeLabel.textAlignment = .right
        
        let divider = UIView()
        contentView.addSubview(divider)
        divider.constraintToSuperview(12, nil, 12, -0.25, ignoreSafeArea: true)
        divider.constraintWidth(to: 0.5)
        divider.backgroundColor = .separator
        
        
        //stackView.addArrangedSubview(changeLabel)
    }
    
    func configure(item:MarketItem) {
        self.item = item
        self.symbolLabel.text = item.symbol
    
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.addObserver(self, selector: #selector(updateTradeDisplay), type: .stockTradeUpdated(item.symbol))
        updateTradeDisplay()
      }
    
    @objc func updateTradeDisplay() {
        changeLabel.text = item?.changePercentStr
        changeLabel.textColor = item?.changeColor
        /*
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
        }*/
    }

    
}
