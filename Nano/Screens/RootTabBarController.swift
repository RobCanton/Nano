//
//  RootTabBarController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//

import Foundation
import UIKit
import SwiftMessages

class RootTabBarController:UITabBarController {
    
    var interactiveModalTransitionDelegate = InteractiveModalTransitionDelegate()
    
    var screen:Screen = .home
    let homeVC:HomeViewController
    let marketDataVC:MarketDataViewController
    let newsVC:NewsPagerViewController
    let notificationsVC:NotificationsViewController
    let settingsVC:UserViewController
    var sideMenu:UIView!
    
    var stockBar:StockBar!
    var stockBarBottomAnchor:NSLayoutConstraint!
    
    init() {
        homeVC = HomeViewController()
        marketDataVC = MarketDataViewController()
        newsVC = NewsPagerViewController()
        notificationsVC = NotificationsViewController()
        settingsVC = UserViewController()
        super.init(nibName: nil, bundle: nil)
        
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem.image = UIImage(named: "home")
        homeNav.tabBarItem.title = "Home"
        //homeNav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let marketDataNav = UINavigationController(rootViewController: marketDataVC)
        marketDataNav.tabBarItem.image = UIImage(systemName: "chart.bar")
        marketDataNav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        let newsNav = UINavigationController(rootViewController: newsVC)
        newsNav.tabBarItem.image = UIImage(named: "news")
        newsNav.tabBarItem.title = "News"
        
        let notificationsNav = UINavigationController(rootViewController: notificationsVC)
        notificationsNav.tabBarItem.image = UIImage(named: "bell")
        notificationsNav.tabBarItem.title = "Alerts"
        
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem.image = UIImage(systemName: "person.crop.circle")
        settingsNav.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        setViewControllers([
            homeNav, newsNav, notificationsNav
        ], animated: false)
        
        sideMenu = UIView()
        sideMenu.backgroundColor = UIColor.systemOrange
        view.addSubview(sideMenu)
        sideMenu.trailingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        sideMenu.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.75).isActive = true
        sideMenu.constraintToSuperview(0, nil, 0, nil, ignoreSafeArea: true)
        
        let button = UIButton()
        button.setTitle("hello", for: .normal)
        sideMenu.addSubview(button)
        button.constraintToCenter(axis: [.x,.y])
        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        
        tabBar.barTintColor = UIColor(white: 0.09, alpha: 1.0)
        view.clipsToBounds = false
        self.view.alpha = 0.0
        
        stockBar = StockBar()
        stockBar.backgroundColor = UIColor(hex: "171717")
        stockBar.delegate = self
        view.insertSubview(stockBar, belowSubview: tabBar)
        stockBar.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: true)
        stockBar.constraintHeight(to: 64)
        stockBarBottomAnchor = stockBar.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: 64)
        stockBarBottomAnchor.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func handleButton() {
        print("heyo!")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.label
        tabBar.isTranslucent = false
        
//        tabBar.setItems([
//            UITabBarItem(title: nil, image: UIImage(named: "chart"), tag: 0)
//        ], animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.addObserver(self, selector: #selector(showSideMenu), type: .showSideMenu)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
            self.view.alpha = 1.0
        }, completion: nil)
        
        NotificationCenter.addObserver(self, selector: #selector(pinStock), type: .pinStock)
        NotificationCenter.addObserver(self, selector: #selector(unpinStock), type: .unpinStock)
    }
   
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    func presentAlert() {
        let random = Double.random(in: 5...8)
        DispatchQueue.main.asyncAfter(deadline: .now() + random, execute: {
            let view: MessageView
            view = MessageView.viewFromNib(layout: .cardView)
            //view.backgroundColor = UIColor.systemBlue
            view.configureContent(title: "TSLA",
                                  body: "TSLA",
                                  iconImage: nil,
                                  iconText: nil,
                                  buttonImage: nil,
                                  buttonTitle: nil,
                                  buttonTapHandler: { _ in SwiftMessages.hide() })
            view.configureTheme(backgroundColor: UIColor.systemBlue, foregroundColor: .label)
            /*view.titleLabel?.textColor = UIColor.label
            view.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            view.bodyLabel?.textColor = UIColor.label
            view.bodyLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)*/
            view.titleLabel?.attributedText = NSAttributedString(string: "TSLA  -  720.45", attributes: [
                 NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .bold)
            ])
            
            let attributedBodyText = NSMutableAttributedString()
//            attributedBodyText.append(NSAttributedString(string: "720.45",
//                                                         attributes: [
//                                                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18.0, weight: .semibold)
//            ]))
//
            attributedBodyText.append(NSAttributedString(string: "Price over 700",
                                                         attributes: [
                                                            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0, weight: .regular)
            ]))
            view.bodyLabel?.attributedText = attributedBodyText
            view.button?.setImage(UIImage(systemName: "chevron.right"), for: .normal)
            view.button?.tintColor = UIColor.white
            view.button?.backgroundColor = UIColor.clear
            view.tapHandler = { _ in
                /*let stock = StockManager.shared.stocks.first!
                let stockVC = StockDetailViewController(stock: stock)
                guard let first = self.viewControllers?.first as? UINavigationController else { return }
                first.pushViewController(stockVC, animated: true)*/
                SwiftMessages.hide()
            }
            
            var config = SwiftMessages.defaultConfig
            config.presentationStyle = .top
            config.presentationContext = .window(windowLevel: .normal)
            config.duration = .seconds(seconds: 5)
            config.interactiveHide = true
            
            SwiftMessages.show(config: config, view: view)
            self.presentAlert()
        })
    }
    
    
    @objc func showSideMenu() {
        var frame = view.frame
        frame.origin.x = view.bounds.width * 0.75
        
        let animator = UIViewPropertyAnimator(duration: 0.3, timingParameters: Easings.Cubic.easeOut)
        animator.addAnimations {
            self.view.frame = frame
        }
        
        animator.startAnimation()
       
    }
    
    @objc func pinStock(_ notification:Notification) {
        guard let item = notification.userInfo?["item"] as? MarketItem else { return }
        stockBarPresent(item: item)
        
    }
    
    @objc func unpinStock(_ notification:Notification) {
        stockBarDismiss()
    }
    
    func stockBarPresent(item:MarketItem) {
        self.stockBar.configure(item: item)
        self.stockBarBottomAnchor.constant = 0
        self.view.layoutIfNeeded()
    }
    
    func stockBarDismiss() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            self.stockBarBottomAnchor.constant = 64
            self.view.layoutIfNeeded()
        }, completion: { _ in
            self.stockBar.deconfigure()
        })
    }
    
   
}

extension RootTabBarController: StockBarDelegate {
    func stockBarDidTap(item: MarketItem) {
        let detailVC = InteractiveDetailViewController(item: item)
        detailVC.transitioningDelegate = interactiveModalTransitionDelegate
        detailVC.modalPresentationStyle = .custom
        
        self.present(detailVC, animated: true, completion: nil)
    }
    
    func stockBarDidLongPress(item: MarketItem) {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Unpin", style: .destructive, handler: { _ in
            self.stockBarDismiss()
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(sheet, animated: true, completion: {
            self.stockBar.resetGestures()
        })
    }
}

