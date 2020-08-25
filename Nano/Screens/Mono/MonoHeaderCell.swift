//
//  MonoHeaderCell.swift
//  Nano
//
//  Created by Robert Canton on 2020-08-09.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class MonoHeaderCell:UITableViewCell {
    
    var stackView:UIStackView!
    var timeLabel:UILabel!
    var hourLabel:UILabel!
    var minuteLabel:UILabel!
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
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 6.0
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(16, 16, 16, 16, ignoreSafeArea: true)
        
        let statusRow = UIView()
        statusRow.constraintHeight(to: 40)
        
        let statusBlock = UIView()
        statusBlock.backgroundColor = .white
        statusBlock.constraintWidth(to: 16)
        statusBlock.constraintHeight(to: 16)
        
        statusRow.addSubview(statusBlock)
        statusBlock.constraintToCenter(axis: [.y])
        statusBlock.constraintToSuperview(nil, 0, nil, nil, ignoreSafeArea: true)
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont.monospacedSystemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = .label
        titleLabel.text = "Market Open"
        
        statusRow.addSubview(titleLabel)
        titleLabel.constraintToCenter(axis: [.y])
        titleLabel.leadingAnchor.constraint(equalTo: statusBlock.trailingAnchor, constant: 12.0).isActive = true
        
        
        
        let dayLabel = UILabel()
        dayLabel.font = UIFont.monospacedSystemFont(ofSize: 32, weight: .bold)
        dayLabel.textColor = .label
        dayLabel.text = "Sunday"
        //dayLabel.textAlignment = .right
        stackView.addArrangedSubview(dayLabel)
        
        let dateLabel = UILabel()
        dateLabel.font = UIFont.monospacedSystemFont(ofSize: 18, weight: .medium)
        dateLabel.textColor = .label
        dateLabel.text = "August 9th"
        //dateLabel.textAlignment = .right
        stackView.addArrangedSubview(dateLabel)
        
        timeLabel = UILabel()
        timeLabel.font = UIFont.monospacedSystemFont(ofSize: 18, weight: .medium)
        //timeLabel.textAlignment = .right
        timeLabel.text = "12:45 PM"

        stackView.addArrangedSubview(timeLabel)
        //contentView.addSubview(timeLabel)
        //timeLabel.constraintToSuperview(nil, nil, nil, 16, ignoreSafeArea: true)
        //timeLabel.lastBaselineAnchor.constraint(equalTo: dateLabel.lastBaselineAnchor).isActive = true
        
//        let spacer = UIView()
//        spacer.constraintHeight(to: 6.0)
//        stackView.addArrangedSubview(spacer)
    
        
        let clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        RunLoop.main.add(clockTimer, forMode: .common)
        
        

//        let stockLabel = UILabel()
//        statusStack.addArrangedSubview(stockLabel)
//        stockLabel.font = UIFont.monospacedSystemFont(ofSize: 18.0, weight: .medium)
//        stockLabel.text = "Settings"
//        stockLabel.textColor = UIColor.systemBlue
//        stockLabel.textAlignment = .right
//
//        let alertsLabel = UILabel()
//        statusStack.addArrangedSubview(alertsLabel)
//        alertsLabel.font = UIFont.monospacedSystemFont(ofSize: 18.0, weight: .medium)
//        alertsLabel.text = "Messages"
//        alertsLabel.textColor = UIColor.systemBlue
//        alertsLabel.textAlignment = .right
//
//
//        let settingsLabel = UILabel()
//        statusStack.addArrangedSubview(settingsLabel)
//        settingsLabel.font = UIFont.monospacedSystemFont(ofSize: 18.0, weight: .medium)
//        settingsLabel.text = "Alerts"
//        settingsLabel.textColor = UIColor.systemBlue
//        settingsLabel.textAlignment = .right
        
//        let forexLabel = UILabel()
//        statusStack.addArrangedSubview(forexLabel)
//        forexLabel.font = UIFont.monospacedSystemFont(ofSize: 14.0, weight: .regular)
//        forexLabel.text = "▓ Forex"
//        forexLabel.textColor = UIColor(hex: "0EE77B")
//
//        let cryptoLabel = UILabel()
//        statusStack.addArrangedSubview(cryptoLabel)
//        cryptoLabel.font = UIFont.monospacedSystemFont(ofSize: 14.0, weight: .regular)
//        cryptoLabel.text = "▓ Crypto"
//        cryptoLabel.textColor = UIColor(hex: "0EE77B")
                
        
    }
    
    @objc func updateTime() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        timeLabel.text = formatter.string(from: now)
        
    }
}
