//
//  TitleCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-18.
//

import Foundation
import UIKit

class TitleCell:UITableViewCell {
    var titleLabel:UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(18, 12, 6, 12, ignoreSafeArea: true)
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = UIColor.secondaryLabel
        selectionStyle = .none
    }
}

