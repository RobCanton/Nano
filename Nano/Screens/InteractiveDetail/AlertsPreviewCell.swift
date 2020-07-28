//
//  AlertsPreviewCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-18.
//

import Foundation
import UIKit

class ActionCell: UITableViewCell {
    
    //private(set) var button:UIButton!
    
    
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
        //self.textLabel?.text = "Create Alert"
        self.textLabel?.textColor = UIColor.systemBlue
        self.textLabel?.textAlignment = .center
    }
    
    
}

