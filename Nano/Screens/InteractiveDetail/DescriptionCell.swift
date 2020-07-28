//
//  DescriptionCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-18.
//

import Foundation
import UIKit


class DescriptionCell: UITableViewCell {
        
    var bodyLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.systemBackground
        bodyLabel = UILabel()
        contentView.addSubview(bodyLabel)
        bodyLabel.constraintToSuperview(12, 12, 12, 12, ignoreSafeArea: true)
        bodyLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        bodyLabel.numberOfLines = 2
        
    }
    
}
