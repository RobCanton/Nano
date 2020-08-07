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
    var segmentedControl:UISegmentedControl!
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
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        titleLabel.textColor = .secondaryLabel
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(4, 16, nil, 16, ignoreSafeArea: true)
        titleLabel.text = "Reset After"
        
        segmentedControl = UISegmentedControl(items: [
            "5m", "15m", "30m", "1h", "EOD", "Never"
        ])
        
        contentView.addSubview(segmentedControl)
        segmentedControl.constraintToSuperview(nil, 16, 20, 16, ignoreSafeArea: true)
        segmentedControl.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true

        segmentedControl.selectedSegmentTintColor = Theme.current.primary
        segmentedControl.selectedSegmentIndex = 1
        
        //segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
        
    }
}
