//
//  IndexHeaderCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-23.
//

import Foundation
import UIKit
import MKGradientView

class IndexHeaderCell:UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var closeButton:UIButton!
    var collectionView:UICollectionView!
    
    var isScrolling = false
    var speed:CGFloat = 0.25
    
    struct IndexPair {
        let symbol:String
        let change:String
    }
    
    let pairs = [
        IndexPair(symbol: "DIA", change: "1.65%"),
        IndexPair(symbol: "SPY", change: "1.32%"),
        IndexPair(symbol: "QQQ", change: "1.14%"),
        IndexPair(symbol: "X:BTC", change: "0.89%")
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
        self.backgroundColor = .opaqueSeparator
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let width = UIScreen.main.bounds.width / 3
        layout.itemSize = CGSize(width: width, height: 44)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        contentView.addSubview(collectionView)
        collectionView.constraintToSuperview()
        collectionView.constraintHeight(to: 44)
        collectionView.register(IndexCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
//        let timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(nextTick), userInfo: nil, repeats: true)
//        //RunLoop.current.add(timer, forMode: .common)
        
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pairs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! IndexCell
        let pair = pairs[indexPath.row]
        cell.symbolLabel.text = pair.symbol
        cell.changeLabel.text = "-\(pair.change)"
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

class IndexCell:UICollectionViewCell {
    
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
        symbolLabel.constraintToSuperview(12, 12, 12, nil, ignoreSafeArea: true)
        //stackView.addArrangedSubview(symbolLabel)
        
        changeLabel = UILabel()
        changeLabel.font = UIFont.monospacedSystemFont(ofSize: 14.0, weight: .medium)//systemFont(ofSize: 14.0, weight: .medium)
        changeLabel.textColor = Theme.current.negative
        contentView.addSubview(changeLabel)
        changeLabel.constraintToSuperview(nil, 12, 12, 12, ignoreSafeArea: true)
        changeLabel.textAlignment = .right
        //changeLabel.leadingAnchor.constraint(equalTo: symbolLabel.trailingAnchor, constant: 8.0).isActive = true
        
        let divider = UIView()
        contentView.addSubview(divider)
        divider.constraintToSuperview(12, nil, 12, -0.25, ignoreSafeArea: true)
        divider.constraintWidth(to: 0.5)
        divider.backgroundColor = .separator
        
        
        //stackView.addArrangedSubview(changeLabel)
    }
}
