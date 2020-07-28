//
//  InteractiveModalPresentationController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-18.
//

import Foundation
import UIKit

open class InteractiveModalPresentationController: UIPresentationController {
    
    /**
     A wrapper around the presented view so that we can modify
     the presented view apperance without changing
     the presented view's properties
     */
    
    private var isPanning = false
    
    private lazy var panContainerView: PanContainerView = {
        let frame = containerView?.frame ?? .zero
        return PanContainerView(presentedView: presentedViewController.view, frame: frame)
    }()
    
    
    
    /**
     Gesture recognizer to detect & track pan gestures
     */
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        gesture.minimumNumberOfTouches = 1
        gesture.maximumNumberOfTouches = 1
        gesture.delegate = self
        return gesture
    }()
    
    public override var presentedView: UIView {
        return panContainerView
    }
    
    private var tabBarVC:RootTabBarController? {
        return presentingViewController as? RootTabBarController
    }
    private var tabBarView:UIView?
    
    /**
     Dims when presenting pop up modal
     */
    private lazy var backgroundView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        return view
    }()
    
    open override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        
        containerView.addSubview(backgroundView)
        backgroundView.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: true)
        
        containerView.addSubview(presentedView)
        presentedView.addGestureRecognizer(panGestureRecognizer)
        
        
        tabBarView = tabBarVC?.tabBar.snapshotView(afterScreenUpdates: true)
        
        
        
        if let tabBarView = self.tabBarView {
            containerView.addSubview(tabBarView)
            
            var tabFrame = tabBarView.frame
            tabFrame.origin.y = containerView.frame.height - tabFrame.height
            tabBarView.frame = tabFrame
            
            let separator = UIView()
            separator.backgroundColor = UIColor.separator
            separator.alpha = 0.75
            separator.frame = CGRect(x: 0, y: -0.5, width: tabFrame.width, height: 0.5)
            
            tabBarView.addSubview(separator)
            tabBarView.clipsToBounds = false
        }
        
        tabBarVC?.tabBar.isHidden = true
        
        guard let coordinator = presentingViewController.transitionCoordinator else { return }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self?.presentedViewController.setNeedsStatusBarAppearanceUpdate()
            
            if let tabBarView = self?.tabBarView {
                var tabFrame = tabBarView.frame
                tabFrame.origin.y = containerView.frame.height + tabFrame.height
                tabBarView.frame = tabFrame
            }
        }, completion: nil)
    }
    
    open override func dismissalTransitionWillBegin() {
        guard let containerView = containerView else { return }
        guard let coordinator = presentedViewController.transitionCoordinator else { return }
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            self?.presentingViewController.setNeedsStatusBarAppearanceUpdate()
            if let tabBarView = self?.tabBarView {
                var tabFrame = tabBarView.frame
                tabFrame.origin.y = containerView.frame.height - tabFrame.height
                tabBarView.frame = tabFrame
            }
        }, completion: { [weak self] _ in
            self?.tabBarView?.removeFromSuperview()
            self?.tabBarVC?.tabBar.isHidden = false
        })
        
    }
    @objc func handlePanGesture(_ recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            respond(to: recognizer)
            break
        default:
            isPanning = false
            let velocityY = recognizer.velocity(in: presentedView).y
            let topY = presentedView.frame.origin.y
            let progress = topY / presentedView.frame.height
            
            var shouldDismiss = false
            
            if velocityY <= 0 {
                print("keep open")
            } else {
                print("close")
                shouldDismiss = true
            }
            
            if shouldDismiss {
                dismissPresentedViewController()
            } else {
                let animator = UIViewPropertyAnimator(duration: 0.5, timingParameters: Easings.Quint.easeOut)
                animator.addAnimations {
                    self.presentedView.frame.origin.y = 0
                    if let detailVC = self.presentedViewController as? InteractiveDetailViewController {
                        detailVC.transitionPresent()
                    }
                }
                
                animator.isInterruptible = true
                animator.isUserInteractionEnabled = true
                animator.isManualHitTestingEnabled = true
                
                animator.addCompletion( { position in
                    
                })
                
                animator.startAnimation()
            }
            break
        }
    }
    
    func respond(to recognizer: UIPanGestureRecognizer) {
        let translateY = recognizer.translation(in: presentedView).y
        //print("translateY: \(translateY)")
        
        let aframe = presentedView.frame.maxY - (tabBarView!.frame.height + 64)
        let diff = aframe / presentedView.frame.maxY
        
        if presentedView.frame.origin.y + translateY * diff < 0 {
            presentedView.frame.origin.y = 0
        } else {
            presentedView.frame.origin.y += translateY * diff
        }
        
        let progress = presentedView.frame.origin.y / presentedView.bounds.maxY
        //print("progress: \(progress)")
        let adjustedProgress = (presentedView.frame.origin.y) / (presentedView.bounds.maxY - tabBarView!.frame.height - (Constants.headerDisplayHeight))
        if let detailVC = presentedViewController as? InteractiveDetailViewController {
            detailVC.transition(progress: adjustedProgress)
        }
        if let tabBarView = self.tabBarView {
            if progress > 0.5 {
                var tabFrame = tabBarView.frame
                let startY = presentedView.frame.height + tabFrame.height
                tabFrame.origin.y = startY - (tabFrame.height*2) * progress
                tabBarView.frame = tabFrame
            } else {
                var tabFrame = tabBarView.frame
                tabFrame.origin.y = presentedView.frame.height + tabFrame.height
                tabBarView.frame = tabFrame
            }
        }
      
        recognizer.setTranslation(.zero, in: presentedView)
    }
    
    @objc func dismissPresentedViewController() {
        presentedViewController.dismiss(animated: true)
    }

}

extension InteractiveModalPresentationController: UIGestureRecognizerDelegate {
    
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if let pan = gestureRecognizer as? UIPanGestureRecognizer {
            let location = pan.location(in: pan.view)
            print("location: \(location.y)")
            if location.y > Constants.headerDisplayHeight {
                return false
            }
            let touch = pan.translation(in: pan.view)
            let magY = abs(touch.y)
            let magX = abs(touch.x)
            return magX <= magY
            
        }
        return true
        
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
}
