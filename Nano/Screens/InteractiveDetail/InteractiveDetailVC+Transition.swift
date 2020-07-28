//
//  InteractiveDetailVC+Transition.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-14.
//

import Foundation
import UIKit


extension InteractiveDetailViewController {
    func transition(progress:CGFloat) {
//        print("heyo: \(progress)")
        let reverseProgress = 1 - progress
        tableView.alpha = reverseProgress
        //detailPagerVC.view.alpha = reverseProgress
        displayView.updateTransition(progress: reverseProgress)
        let spacing:CGFloat = (Constants.headerDisplayHeight - 64)
        let maxProgress = max(0, min(progress, 1))
        headerTopAnchor.constant = spacing * maxProgress
        view.layoutIfNeeded()
    }
    
    func transitionPresent() {
        tableView.alpha = 1
        //detailPagerVC.view.alpha = 1
        headerTopAnchor.constant = 0
        displayView.updateTransition(progress: 1)
        view.layoutIfNeeded()
    }
    
    func transitionDismiss() {
        tableView.alpha = 0
        //detailPagerVC.view.alpha = 0
        let spacing:CGFloat = (Constants.headerDisplayHeight - 64)
        headerTopAnchor.constant = spacing
        displayView.updateTransition(progress: 0)
        view.layoutIfNeeded()
    }
    
}
