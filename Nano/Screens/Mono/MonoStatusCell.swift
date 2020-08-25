//
//  MonoStatusCell.swift
//  Nano
//
//  Created by Robert Canton on 2020-08-09.
//  Copyright © 2020 Robert Canton. All rights reserved.
//
import Foundation
import UIKit

class MonoStatusCell:UITableViewCell {
    
    var stackView:UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4.0
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(0, 16, 16, 16, ignoreSafeArea: true)

//        let marketStatus = UILabel()
//        stackView.addArrangedSubview(marketStatus)
//        marketStatus.font = UIFont.monospacedSystemFont(ofSize: 14, weight: .semibold)
//        marketStatus.text = "░ Market Closed"
//        marketStatus.textColor = .secondaryLabel

        let stockLabel = UILabel()
        stackView.addArrangedSubview(stockLabel)
        stockLabel.font = UIFont.monospacedSystemFont(ofSize: 14.0, weight: .regular)
        stockLabel.text = "░ Stocks"
        stockLabel.textColor = UIColor.secondaryLabel
        
        let forexLabel = UILabel()
        stackView.addArrangedSubview(forexLabel)
        forexLabel.font = UIFont.monospacedSystemFont(ofSize: 14.0, weight: .regular)
        forexLabel.text = "░ Forex"
        forexLabel.textColor = UIColor.secondaryLabel
        
        let cryptoLabel = UILabel()
        stackView.addArrangedSubview(cryptoLabel)
        cryptoLabel.font = UIFont.monospacedSystemFont(ofSize: 14.0, weight: .regular)
        cryptoLabel.text = "▓ Crypto"
        cryptoLabel.textColor = UIColor(hex: "0EE77B")
        
//        let buttonsRow = UIStackView()
//        buttonsRow.axis = .horizontal
//        buttonsRow.distribution = .fillEqually
//
//        buttonsRow.constraintHeight(to: 44)
//
//        stackView.addArrangedSubview(buttonsRow)
//
//        let types = [
//            "Stocks", "Forex", "Crypto"
//        ]
//
//        for i in 0..<types.count {
//            let type = types[i]
//            let button = UIButton(type: .system)
//            button.setTitle(type, for: .normal)
//            button.setTitleColor(.secondaryLabel, for: .normal)
//            button.titleLabel?.font = UIFont.monospacedSystemFont(ofSize: 16.0, weight: .medium)
//            button.titleLabel?.textAlignment = .left
//            buttonsRow.addArrangedSubview(button)
//        }
        
        
        
    }
    
}
