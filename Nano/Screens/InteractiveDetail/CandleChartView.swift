//
//  CandleChartView.swift
//  Nano
//
//  Created by Robert Canton on 2020-08-07.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class CandleChartView:UIView {
    
    var contentView:UIView!
    var bgView:UIImageView!
    var contentLeadingAnchor:NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        //self.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        
        layer.borderColor = UIColor.systemRed.cgColor
        layer.borderWidth = 1.0
        
        contentView = UIView()
        self.addSubview(contentView)
        contentView.constraintToSuperview(0, nil, 0, nil, ignoreSafeArea: true)
        contentView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 2).isActive = true
        contentLeadingAnchor = contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        contentLeadingAnchor.isActive = true
        
        bgView = UIImageView(image: UIImage(named: "desk"))
        contentView.addSubview(bgView)
        bgView.constraintToSuperview()
        bgView.contentMode = .scaleAspectFill
        bgView.clipsToBounds = true
        
        let screenWidth = UIScreen.main.bounds.width
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            UIView.animate(withDuration: 5.0, animations: {
                self.contentLeadingAnchor.constant = -screenWidth*1
                self.layoutIfNeeded()
            })
        })
        
    }
    
}
