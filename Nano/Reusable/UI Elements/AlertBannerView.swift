//
//  AlertBannerView.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-04.
//

import Foundation
import UIKit

class AlertBannerView: UIView {
    
    var contentView:UIView!
    var button:UIButton!
    
    var title:String? {
        didSet {
            button.setTitle(title, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        contentView = UIView()
        self.addSubview(contentView)
        contentView.constraintToSuperview()
        contentView.backgroundColor = UIColor.systemBlue
        
        contentView.layer.cornerRadius = 10.0
        contentView.layer.cornerCurve = .continuous
        contentView.clipsToBounds = true
        
        self.applyShadow(radius: 12.0,
                         opacity: 0.15,
                         offset: .zero,
                         color: .black,
                         shouldRasterize: false)
        
        button = UIButton(type: .system)
        contentView.addSubview(button)
        button.constraintToSuperview()
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        
    }
}
