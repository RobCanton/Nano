//
//  AlertMessageCell.swift
//  Nano
//
//  Created by Robert Canton on 2020-08-08.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class AlertMessageCell:UITableViewCell {
    
    var textView:UITextView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        textView = UITextView()
        contentView.addSubview(textView)
        textView.constraintToSuperview(8, 12, 12, 12, ignoreSafeArea: true)
        textView.constraintHeight(to: 44)
    }
}
