//
//  AlertDividerCell.swift
//  Nano
//
//  Created by Robert Canton on 2020-07-29.
//  Copyright © 2020 Robert Canton. All rights reserved.
//


import Foundation
import UIKit

class AlertDividerCell:UITableViewCell {
  
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
        let divider = UIView()
        contentView.addSubview(divider)
        divider.constraintHeight(to: 0.5)
        divider.constraintToSuperview(12, 16, 12, 16, ignoreSafeArea: true)
        divider.backgroundColor = .separator
        
    }
}
