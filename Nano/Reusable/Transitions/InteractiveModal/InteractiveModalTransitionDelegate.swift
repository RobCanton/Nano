//
//  InteractiveModalTransitionDelegate.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-18.
//

import Foundation
import UIKit


public class InteractiveModalTransitionDelegate: NSObject {
    var tabBarView:UIView?
}

extension InteractiveModalTransitionDelegate: UIViewControllerTransitioningDelegate  {

    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return InteractiveModalPresentationAnimator(transitionStyle: .presentation)
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        return InteractiveModalPresentationAnimator(transitionStyle: .dismissal)
    }
    
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let controller = InteractiveModalPresentationController(presentedViewController: presented, presenting: presenting)
        controller.delegate = self
        return controller
    }
 
}

extension InteractiveModalTransitionDelegate: UIAdaptivePresentationControllerDelegate, UIPopoverPresentationControllerDelegate {

    public func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }

}
