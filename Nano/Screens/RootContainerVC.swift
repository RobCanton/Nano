//
//  RootContainerViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-16.
//

import Foundation
import UIKit

class RootContainerViewController:UIViewController {
    var scrollView:UIScrollView!
    var rootTabBarController:RootTabBarController!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemTeal
        
        scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: true)
        scrollView.contentSize = CGSize(width: view.bounds.width * 1.75, height: view.bounds.height)
        
        scrollView.backgroundColor = UIColor.systemPink
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor.systemOrange
        scrollView.addSubview(contentView)
        contentView.constraintToSuperview()
        contentView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.75).isActive = true
        contentView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        
        scrollView.setContentOffset(CGPoint(x: view.bounds.width * 0.75, y: 0), animated: false)
        //scrollView.showsHorizontalScrollIndicator = false
        rootTabBarController = RootTabBarController()
        rootTabBarController.willMove(toParent: self)
        self.addChild(rootTabBarController)
        contentView.addSubview(rootTabBarController.view)
        rootTabBarController.view.constraintToSuperview(0, nil, 0, 0, ignoreSafeArea: true)
        rootTabBarController.view.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        rootTabBarController.didMove(toParent: self)
        
    }
}
