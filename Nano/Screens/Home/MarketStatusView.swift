//
//  MarketStatusView.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-23.
//

import Foundation
import UIKit


class MarketStatusView:UIView {
    var iconView:UIView!
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
        //self.backgroundColor = UIColor.systemRed
        iconView = UIView()
        self.addSubview(iconView)
        iconView.constraintToCenter(axis: [.y])
        iconView.constraintToSuperview(nil, 0, nil, nil, ignoreSafeArea: true)
        iconView.constraintWidth(to: 10)
        iconView.constraintHeight(to: 10)
        iconView.layer.cornerRadius = 10/2
        iconView.clipsToBounds = true
        
        //iconView.backgroundColor = Theme.current.positive
        iconView.backgroundColor = UIColor.systemFill
        
        titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.constraintToSuperview(0, nil, 0, 12, ignoreSafeArea: true)
        titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8).isActive = true
        titleLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        titleLabel.text = "Markets Closed"
        titleLabel.textColor = UIColor.secondaryLabel
    }
    
    func displayStatus(_ status:MarketStatus) {
        titleLabel.text = status.displayString
        titleLabel.textColor = status.textColor
        iconView.backgroundColor = status.color
        
    }
}
