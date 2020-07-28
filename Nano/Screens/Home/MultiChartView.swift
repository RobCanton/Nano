//
//  MultiChartView.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-14.
//

import Foundation
import UIKit


class MultiChartView:UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var stock:Stock?
    var liveChartView:LiveChartView!
    var chartView:ChartView!
    var collectionView:UICollectionView!
    var selectedTimeframe:AggregateTimeframe = .live
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        let backdrop = UIView()
        //backdrop.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.075)
        self.addSubview(backdrop)
        backdrop.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        
        liveChartView = LiveChartView()
        self.addSubview(liveChartView)
        liveChartView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        backdrop.heightAnchor.constraint(equalTo: liveChartView.heightAnchor).isActive = true
        liveChartView.isHidden = true
        
        chartView = ChartView()
        self.addSubview(chartView)
        chartView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        chartView.heightAnchor.constraint(equalTo: liveChartView.heightAnchor).isActive = true
        chartView.isHidden = true
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.itemSize = CGSize(width: 100, height: 100)
        layout.estimatedItemSize = CGSize(width: 52, height: 32)
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: liveChartView.bottomAnchor, constant: 12).isActive = true
        collectionView.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: false)
        collectionView.constraintHeight(to: 32)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(ChartOptionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
    }
    
    func configure(_ stock:Stock) {
        self.stock = stock
        displayTrades(stock.trades, sign: stock.sign)
        
        if MarketManager.shared.marketStatus == .closed {
            selectedTimeframe = .oneDay
            collectionView.selectItem(at: IndexPath(item: 1, section: 0), animated: false, scrollPosition: .left)
            chartView.isHidden = false
            liveChartView.isHidden = true
            getAggregate(for: .oneDay)
        } else {
            selectedTimeframe = .live
            collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .centeredHorizontally)
            chartView.isHidden = true
            liveChartView.isHidden = false
        }
    }
    
    func displayTrades(_ trades:[Stock.Trade], sign:Sign) {
        if selectedTimeframe == .live {
            liveChartView.displayTrades(trades, positive: sign == .positive)
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AggregateTimeframe.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ChartOptionCell
        cell.titleLabel.text = AggregateTimeframe.list[indexPath.row].rawValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let stock = self.stock else { return }
        
        let timeframe =  AggregateTimeframe.list[indexPath.row]
        if timeframe == self.selectedTimeframe {
            return
        }
        self.selectedTimeframe = timeframe
        if timeframe == .live {
            liveChartView.isHidden = false
            chartView.isHidden = true
        } else {
            liveChartView.isHidden = true
            chartView.isHidden = false
            
            getAggregate(for: timeframe)
        }
        
    }
    
    func getAggregate(for timeframe:AggregateTimeframe) {
        guard let stock = self.stock else { return }
        chartView.startLoading()
        RavenAPI.getAggregatePreset(for: stock.symbol,
                                    timeframe: timeframe) { timeframe, data in
                                        guard let data = data else { return }
                                        guard self.selectedTimeframe == timeframe else { return }
                                        let guide = timeframe == .oneDay ? self.stock?.previousClose?.close : nil
                                        self.chartView.displayTicks(data, sign: stock.sign, guide: guide)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 32)
    }
    
}

class ChartOptionCell:UICollectionViewCell {
    var titleLabel:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        titleLabel.textColor = UIColor.secondaryLabel
        contentView.addSubview(titleLabel)
        titleLabel.constraintToCenter(axis: [.y,.x])
        titleLabel.textAlignment = .center
        self.layer.cornerRadius = 8
        self.layer.cornerCurve = .continuous
        self.clipsToBounds = true
    }
    
    
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                titleLabel.textColor = .label
                titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
                self.backgroundColor = UIColor.label.withAlphaComponent(0.2)
                
            } else {
                titleLabel.textColor = .secondaryLabel
                titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
                self.backgroundColor = UIColor.clear
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted {
                titleLabel.textColor = .label
                self.backgroundColor = UIColor.label.withAlphaComponent(0.1)
            } else {
                titleLabel.textColor = .secondaryLabel
                self.backgroundColor = UIColor.clear
            }
        }
    }
}
