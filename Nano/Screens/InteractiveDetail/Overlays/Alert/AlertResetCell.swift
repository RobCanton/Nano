//
//  AlertDelieveryCell.swift
//  Nano
//
//  Created by Robert Canton on 2020-07-29.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class AlertResetCell:UITableViewCell {
    var titleLabel:UILabel!
    var stackView:UIStackView!
    //var segmentedControl:UISegmentedControl!
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
        self.backgroundColor = UIColor.systemBackground
        
        stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(12, 12, 12, 12, ignoreSafeArea: true)
        stackView.axis = .vertical
        stackView.spacing = 12.0
        
//        let topSpacer = UIView()
//        topSpacer.constraintHeight(to: 4)
//        stackView.addArrangedSubview(topSpacer)
//        
//        titleLabel = UILabel()
//        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
//        titleLabel.textColor = .secondaryLabel
//        //contentView.addSubview(titleLabel)
//        //titleLabel.constraintToSuperview(16, 16, nil, 16, ignoreSafeArea: true)
//        titleLabel.text = "Reset After"
//        
//        stackView.addArrangedSubview(titleLabel)
//        
//        addDivider()
        
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8.0
        stackView.addArrangedSubview(row)
//        contentView.addSubview(row)
//        row.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.0).isActive = true
//        row.constraintToSuperview(nil, 16, 16, 16, ignoreSafeArea: true)
        
        row.constraintHeight(to: 40)
        row.distribution = .fillEqually
        
        let buttons = [
            "1m", "5m", "30m", "1h", "EOD", "Never"
        ]
        
        for i in 0..<buttons.count {
            let button = SelectorButton(type: .custom)
            button.setTitle(buttons[i], for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            //button.setBackgroundColor(color: .clear, forState: .normal)
            //button.setBackgroundColor(color: .systemFill, forState: .selected)
            button.isSelected = i == 0
            button.layer.cornerRadius = 3.0
            button.clipsToBounds = true
            //button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
            button.tag = i
//            /typeButtons.append(button)
            row.addArrangedSubview(button)
        }
        
    }
    
    func addDivider() {
        let divider = UIView()
        divider.constraintHeight(to: 0.5)
        divider.backgroundColor = .separator
        stackView.addArrangedSubview(divider)
    }
}
