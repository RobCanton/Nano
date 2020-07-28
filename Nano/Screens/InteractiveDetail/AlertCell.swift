//
//  AlertCell.swift
//  Nano
//
//  Created by Robert Canton on 2020-07-27.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class AlertCell:UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
