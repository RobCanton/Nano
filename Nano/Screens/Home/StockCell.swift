//
//  StockCell3.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-12.
//

import Foundation
import UIKit

class StockCell:UITableViewCell {
    
    weak var stock:Stock?
    
    private(set) var stockRow:StockRow!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        stockRow = StockRow()
        contentView.addSubview(stockRow)
        stockRow.constraintToSuperview()
    }
    
    func configure(item:MarketItem) {
        self.stockRow.configure(item: item)
    }
    

}

extension StockCell: StockDelegate {
    func stockDidUpdate() {
        //updateDisplay()
    }
}
