//
//  EditUsernameCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-22.
//

import Foundation
import UIKit

class EditUsernameCell:UITableViewCell {
    
    var textField:UITextField!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        textField = UITextField()
        contentView.addSubview(textField)
        textField.constraintToSuperview(12, 12, 12, 12, ignoreSafeArea: true)
        textField.placeholder = "Username"
        textField.textAlignment = .center
        textField.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        textField.autocapitalizationType = .none
    }
    
}
