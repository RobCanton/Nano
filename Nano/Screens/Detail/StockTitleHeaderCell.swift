//
//  StockTitleHeaderCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-13.
//

import Foundation
import UIKit

class StockTitleHeaderCell:UITableViewCell {
    
    var titleLabel:UILabel!
    var button:UIButton!
    
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
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(16, 16, 16, 16, ignoreSafeArea: false)
        titleLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .bold)
        titleLabel.textColor = UIColor.label
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        
        button = UIButton(type: .system)
        contentView.addSubview(button)
        button.constraintToSuperview(0, nil, 0, 16, ignoreSafeArea: false)
        
        
    }
    
}
