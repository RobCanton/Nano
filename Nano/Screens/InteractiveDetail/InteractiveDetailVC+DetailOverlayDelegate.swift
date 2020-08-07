//
//  InteractiveDetailViewController+DetailOverlayDelegate.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-20.
//

import Foundation
import UIKit

extension InteractiveDetailViewController: OverlayDelegate {
    func presentOverlay(_ type:OverlayType) {
        
        currentOverlay = nil
        overlayBottomAnchor = nil
        var targetHeaderHeight:CGFloat = Constants.headerDisplayHeight
        var shiftUp:CGFloat = 0
        
        var overlayVC:OverlayViewController
        switch type {
        case .chat:
            overlayVC = DetailCommentsPageVC(item: item)
            break
        case .alert:
            overlayVC = EditAlertOverlayViewController(item: item,
                                                        alert: nil)
            //shiftUp = 30
            break
        }
        targetHeaderHeight -= shiftUp
        currentOverlayType = type
        
        overlayVC.delegate = self
        
        //
        
        currentOverlay = UINavigationController(rootViewController: overlayVC)
        currentOverlay!.willMove(toParent: self)
        view.addSubview(currentOverlay!.view)
        self.addChild(currentOverlay!)
        
        let overlayHeight = tableView.bounds.height
        
        currentOverlay!.view.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: false)
        currentOverlay!.view.heightAnchor.constraint(equalToConstant: overlayHeight).isActive = true
        
        overlayBottomAnchor = currentOverlay!.view.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                                           constant: overlayHeight)
        overlayBottomAnchor.isActive = true
        
        self.view.layoutIfNeeded()
        
        
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            self.dimmerView.alpha = 1.0
            self.overlayBottomAnchor.constant = 0
            self.headerHeightAnchor.constant = targetHeaderHeight
            self.view.layoutIfNeeded()
        }, completion: { _ in
            
        })
        
        
    }
    
    func overlayDidDismiss() {
        guard let currentOverlay = currentOverlay,
            let overlayBottomAnchor = overlayBottomAnchor else { return }
        
        //currentOverlay.willMove(toParent: nil)
//        let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: Easings.Quint.easeOut)
//        animator.addAnimations {
//            self.dimmerView.alpha = 0.0
//            self.overlayBottomAnchor.constant = self.tableView.bounds.height
//            self.headerHeightAnchor.constant = 220
//            self.view.layoutIfNeeded()
//        }
//        animator.addCompletion { position in
//            if position == .end {
//                currentOverlay.view.removeFromSuperview()
//                currentOverlay.didMove(toParent: nil)
//                currentOverlay.removeFromParent()
//                self.currentOverlay = nil
//                self.overlayBottomAnchor = nil
//                self.currentOverlayType = nil
//            }
//        }
//        animator.startAnimation()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
            self.dimmerView.alpha = 0.0
            self.overlayBottomAnchor.constant = currentOverlay.view.bounds.height
            self.headerHeightAnchor.constant = Constants.headerDisplayHeight
            self.view.layoutIfNeeded()
        }, completion: { _ in
            currentOverlay.view.removeFromSuperview()
            currentOverlay.didMove(toParent: nil)
            currentOverlay.removeFromParent()
            self.currentOverlay = nil
            self.overlayBottomAnchor = nil
            self.currentOverlayType = nil
        })
    }
}
