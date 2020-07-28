//
//  StockFundamentalsCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-12.
//

import Foundation
import UIKit

class StockFundamentalsCell:UITableViewCell {
    var stackView:UIStackView!
    var leftColumnView:UIStackView!
    var rightColumnView:UIStackView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        contentView.backgroundColor = UIColor.clear
        stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 12.0
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(8, 16, 8, 16, ignoreSafeArea: false)
        
        leftColumnView = UIStackView()
        leftColumnView.distribution = .fillEqually
        leftColumnView.axis = .vertical
        leftColumnView.spacing = 1.0
        
        stackView.addArrangedSubview(leftColumnView)
        
        rightColumnView = UIStackView()
        rightColumnView.distribution = .fillEqually
        rightColumnView.axis = .vertical
        rightColumnView.spacing = 1.0
        stackView.addArrangedSubview(rightColumnView)
        
        addStatToLeftColumn(title: "Prev Close", value: "40.00")
        addStatToLeftColumn(title: "Open", value: "42.53")
        addStatToLeftColumn(title: "High", value: "39.56")
        addStatToLeftColumn(title: "Low", value: "39.56")
        addStatToRightColumn(title: "52wk High", value: "4.43%")
        addStatToRightColumn(title: "Mkt Cap", value: "8.30M")
        addStatToRightColumn(title: "Vol", value: "12.65B")
        addStatToRightColumn(title: "P/E", value: "-")
        
        
    }
    
    func addStatToLeftColumn(title:String, value:String) {
        let statView = FundamentalStatRow(title: title, value: value)
        leftColumnView.addArrangedSubview(statView)
    }
    func addStatToRightColumn(title:String, value:String) {
        let statView = FundamentalStatRow(title: title, value: value)
        rightColumnView.addArrangedSubview(statView)
    }
    
}

class FundamentalStatRow:UIView {
    private var stackView:UIStackView!
    private var titleLabel:UILabel!
    private var valueLabel:UILabel!
    private var title:String
    private var value:String
    init(title:String, value:String) {
        self.title = title
        self.value = value
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        stackView = UIStackView()
        stackView.axis = .horizontal
        
        self.addSubview(stackView)
        stackView.constraintToSuperview()
        
        titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        titleLabel.textColor = .secondaryLabel
        
        valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.textAlignment = .right
        valueLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        valueLabel.textColor = .label
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(valueLabel)
    }
}
