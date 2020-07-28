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
    
    struct IndexPair {
        let symbol:String
        let change:String
    }
    
    let pairs = [
        IndexPair(symbol: "AMD", change: "4.63%"),
        IndexPair(symbol: "FE", change: "2.97%"),
        IndexPair(symbol: "MAT", change: "9.69%"),
        IndexPair(symbol: "EW", change: "5.04%"),
        IndexPair(symbol: "INTC", change: "11.46%"),
        IndexPair(symbol: "AAPL", change: "4.21%"),
        IndexPair(symbol: "AUY", change: "0.94%")
    ]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.estimatedItemSize = CGSize(width: 150, height: 32)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        contentView.addSubview(collectionView)
        collectionView.constraintToSuperview()
        collectionView.constraintHeight(to: 32)
        collectionView.register(TrendingCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        let timer = Timer.scheduledTimer(timeInterval: 0.025, target: self, selector: #selector(nextTick), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .common)
        
        let divider = UIView()
        contentView.addSubview(divider)
        divider.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
        divider.constraintHeight(to: 0.5)
        divider.backgroundColor = .separator
        
        
    }
    
    func configure() {
        collectionView.setNeedsLayout()
        collectionView.layoutIfNeeded()
        collectionView.reloadData()
    }
    
    @objc func nextTick() {
        if isScrolling { return }
        let offsetX = collectionView.contentOffset.x
        let nextOffsetX = offsetX + 1
        collectionView.contentOffset = CGPoint(x: nextOffsetX, y: 0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 999
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pairs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrendingCell
        let pair = pairs[indexPath.row]
        cell.symbolLabel.text = pair.symbol
        cell.changeLabel.text = pair.change
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
    
    var symbolLabel:UILabel!
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
//        let stackView = UIStackView()
//        stackView.axis = .horizontal
//        contentView.addSubview(stackView)
//        stackView.constraintToSuperview(12, 12, 12, 12, ignoreSafeArea: true)
//        stackView.spacing = 12.0
        
        //constraintHeight(to: 32)
        symbolLabel = UILabel()
        symbolLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        contentView.addSubview(symbolLabel)
        symbolLabel.constraintToSuperview(0, 12, 0, nil, ignoreSafeArea: true)
        symbolLabel.constraintHeight(to: 32)
        //stackView.addArrangedSubview(symbolLabel)
        
        changeLabel = UILabel()
        changeLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        changeLabel.textColor = Theme.current.negative
        contentView.addSubview(changeLabel)
        changeLabel.constraintToSuperview(0, nil, 0, 12, ignoreSafeArea: true)
        
        changeLabel.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 8).isActive = true
        //stackView.addArrangedSubview(changeLabel)
    }
}
