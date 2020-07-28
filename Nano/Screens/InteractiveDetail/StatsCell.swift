//
//  StatsCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-20.
//

import Foundation
import UIKit

class StatsCell: UITableViewCell {
    
    //private(set) var nameLabel:UILabel!
    private(set) var collectionView:UICollectionView!
    private(set) var actionsRow:UIStackView!
    
    var stats = [StatValue]()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.systemBackground
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let numItems:CGFloat = 5
        let playableWidth = UIScreen.main.bounds.width - (12 * 2) - (12 * (numItems-1))
        let width = playableWidth / numItems
        
        layout.itemSize = CGSize(width: width, height: 52)
        layout.minimumLineSpacing = 12.0
    
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.addSubview(collectionView)
        collectionView.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: false)
        collectionView.constraintHeight(to: 64)
        collectionView.backgroundColor = UIColor.clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        collectionView.register(StatCollectionCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
    }
    
    func configure(item:MarketItem) {
        self.stats = item.stats
        self.collectionView.reloadData()
    }
    
    
}

extension StatsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! StatCollectionCell
        let stat = stats[indexPath.row]
        cell.titleLabel.text = stat.type.rawValue
        cell.valueLabel.text = stat.value
        return cell
    }
    
    
}

class StatCollectionCell: UICollectionViewCell {
    var titleLabel:UILabel!
    var valueLabel:UILabel!
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
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(8, 0, nil, 0, ignoreSafeArea: true)
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = UIColor.secondaryLabel
        titleLabel.text = "Mkt Cap"
        
        valueLabel = UILabel()
        contentView.addSubview(valueLabel)
        valueLabel.constraintToSuperview(nil, 0, 8, 0, ignoreSafeArea: true)
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        valueLabel.textColor = UIColor.secondaryLabel
        valueLabel.text = "128.4k"
    }
}


class StatView:UIView {
    var titleLabel:UILabel
    var valueLabel:UILabel
    
    var title:String {
        didSet {
            titleLabel.text = title
        }
    }
    var value:String {
        didSet {
            valueLabel.text = value
        }
    }
    init(title:String, value:String) {
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        titleLabel.textColor = UIColor.secondaryLabel
        titleLabel.text = title
        
        valueLabel = UILabel()
        valueLabel.textColor = UIColor.secondaryLabel
        valueLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        valueLabel.text = value
        
        self.title = title
        self.value = value
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.clear
        let stackView = UIStackView()
        stackView.axis = .vertical

        addSubview(stackView)
        stackView.constraintToSuperview()
        stackView.spacing = 3.0
        
        stackView.addArrangedSubview(titleLabel)
        
        stackView.addArrangedSubview(valueLabel)
        
    }
}

