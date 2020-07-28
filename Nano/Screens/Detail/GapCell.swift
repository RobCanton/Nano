//
//  File.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-18.
//

import Foundation
import UIKit


class GapCell:UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    @objc func setup() {
        self.constraintHeight(to: 16)
        self.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}
