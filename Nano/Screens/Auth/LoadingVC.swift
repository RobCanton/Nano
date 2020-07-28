//
//  SetupViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-17.
//

import Foundation
import UIKit
import Lottie


class LoadingViewController: UIViewController {
    
    var animationView:AnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        let a = Animation.named("pixel_square_3")
                
        animationView = AnimationView(animation: a)
        
        view.addSubview(animationView)
        animationView.constraintToCenter(axis: [.x,.y])
        animationView.constraintWidth(to: 44)
        animationView.constraintHeight(to: 44)
        
        //animationView.tintColor = UIColor.white
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        animationView.alpha = 1.0
        animationView.play()
        
//
        /// A keypath that finds the color value for all `Fill 1` nodes.
        let fillKeypath = AnimationKeypath(keypath: "**.Fill 1.Color")
        /// A Color Value provider that returns a reddish color.
        let redValueProvider = ColorValueProvider(Color(r: 1, g: 1, b: 1, a: 1))
        /// Set the provider on the animationView.
        animationView.setValueProvider(redValueProvider, keypath: fillKeypath)
        
        let fillKeypath2 = AnimationKeypath(keypath: "**.Stroke 1.Color")
        /// A Color Value provider that returns a reddish color.
        //let redValueProvider = ColorValueProvider(Color(r: 1, g: 1, b: 1, a: 1))
        /// Set the provider on the animationView.
        animationView.setValueProvider(redValueProvider, keypath: fillKeypath2)
//        let a = Animation.named("pixel_square_3")
//
//        animationView = AnimationView(animation: a)
//        view.addSubview(animationView)
//        animationView.constraintToCenter(axis: [.x,.y])
//        animationView.constraintWidth(to: 52)
//        animationView.constraintHeight(to: 52)
//        animationView.play()
//        animationView.tintColor = UIColor.label
//        animationView.loopMode = .loop
//        animationView.animationSpeed = 1.5
//        animationView.alpha = 0.0
//
//        /// A keypath that finds the color value for all `Fill 1` nodes.
//        let fillKeypath = AnimationKeypath(keypath: "**.Fill 1.Color")
//        /// A Color Value provider that returns a reddish color.
//        let redValueProvider = ColorValueProvider(Color(r: 1, g: 1, b: 1, a: 1))
//        /// Set the provider on the animationView.
//        animationView.setValueProvider(redValueProvider, keypath: fillKeypath)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            self.animationView.alpha = 1.0
        }, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func fadeout(completion: @escaping()->()) {
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {
            self.animationView.alpha = 0.0
        }, completion: { _ in
            completion()
        })
    }
}
