//
//  OverlayNavBar.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-20.
//

import Foundation
import UIKit



class OverlayNavBar:UIView {
    
    var titleLabel:UILabel!
    var rightButton:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        titleLabel = UILabel()
        self.addSubview(titleLabel)
        titleLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        titleLabel.constraintToSuperview(0, 12, 0, nil, ignoreSafeArea: false)
        
        rightButton = UIButton(type: .system)
        self.addSubview(rightButton)
        rightButton.constraintToSuperview(0, nil, 0, 2, ignoreSafeArea: false)
        rightButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        rightButton.tintColor = UIColor.label
        rightButton.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        titleLabel.trailingAnchor.constraint(equalTo: rightButton.leadingAnchor, constant: -12).isActive = true
        
        let divider = UIView()
        self.addSubview(divider)
        divider.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: false)
        divider.constraintHeight(to: 0.5)
        divider.backgroundColor = UIColor.separator
    }
    
}
