//
//  DetailKeyStatsCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-14.
//

import Foundation
import UIKit


class DetailKeyStatsCell:UITableViewCell {
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
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(12, 16, 12, 16, ignoreSafeArea: false)
        //stackView.constraintHeight(to: 44)
        
        addStat(title: "Open", value: "27.66")
        addStat(title: "Low", value: "25.53")
        addStat(title: "High", value: "29.70")
        addStat(title: "Volume", value: "19.33m")
        addStat(title: "Mkt Cap", value: "454.5m")
    }
    
    func addStat(title:String, value:String) {
        let statView = StatView(title: title, value: value)
        stackView.addArrangedSubview(statView)
    }
}

