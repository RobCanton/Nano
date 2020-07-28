//
//  StockListCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-17.
//

import Foundation
import UIKit

protocol StockListDelegate:class {
    func stockList(didSelect stock:Stock)
}

class StockListCell:UITableViewCell {
    
    weak var delegate:StockListDelegate?
    
    var list = [MarketItem]()
    var collectionView:UICollectionView!
    var itemSize:CGSize = .zero
    
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
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        //layout.itemSize = CGSize(width: 100, height: 100)
        let width = UIScreen.main.bounds.width / 4
        let height = width * 1.45
        itemSize = CGSize(width: width, height: height)
        layout.itemSize = itemSize
        layout.minimumLineSpacing = 12
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        contentView.addSubview(collectionView)
        collectionView.constraintToSuperview(12, 0, 12, 0, ignoreSafeArea: true)
        collectionView.constraintHeight(to: height)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(StockBoxCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        //collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
    }
    
    func configure(list:[MarketItem]) {
        self.list = list
        self.collectionView.reloadData()
    }
}

extension StockListCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StockBoxCell
        
        cell.configure(stock: list[indexPath.row] as! Stock)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.stockList(didSelect: list[indexPath.row] as! Stock)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    
}

