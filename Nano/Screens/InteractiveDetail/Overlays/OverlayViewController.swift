//
//  DetailOverlayViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-19.
//

import Foundation
import UIKit

enum OverlayType {
    case alert
    case chat
}

protocol OverlayDelegate:class {
    func overlayDidDismiss()
}

class OverlayViewController:UIViewController {
    
    weak var delegate:OverlayDelegate?
    
    //var navBar:OverlayNavBar!
    var contentView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.secondarySystemGroupedBackground
        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.view.layer.cornerRadius = 12
//        self.navigationController?.view.clipsToBounds = true
        
        
//        view.backgroundColor = UIColor.systemBackground
//        navBar = OverlayNavBar()
//        view.addSubview(navBar)
//        navBar.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: true)
//        navBar.constraintHeight(to: 44)
//        navBar.titleLabel.text = "Default Title"
//        navBar.rightButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        contentView = UIView()
        view.addSubview(contentView)
        contentView.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: false)
//        /contentView.topAnchor.constraint(equalTo: navBar.bottomAnchor).isActive = true
    }
    
    @objc func handleDismiss() {
        delegate?.overlayDidDismiss()
    }
}
