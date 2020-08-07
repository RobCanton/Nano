//
//  InteractiveDetailViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-18.
//

import Foundation
import UIKit
//import GoogleMobileAds
import Parchment
import AVFoundation

protocol DetailMasterDelegate:class {
    func presentAlertOverlay()
}



class InteractiveDetailViewController:UIViewController {
    
    let item:MarketItem
    var alerts:[Alert]
    var news = [News]()
    
    //var adLoader: GADAdLoader!
    let adUnitID = "ca-app-pub-3940256099942544/3986624511"
    //var nativeAd: GADUnifiedNativeAd?
    
    init(item:MarketItem) {
        self.item = item
        self.alerts = AlertManager.shared.alerts(for: item.symbol)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var headerBox:UIView!
    var displayView:HeaderDisplayView!
    var headerHeightAnchor:NSLayoutConstraint!
    var headerTopAnchor:NSLayoutConstraint!
    var headerBottomAnchor:NSLayoutConstraint!
    var tableView:UITableView!
    var toolBar:UIToolbar!
    
    var detailPagerVC:DetailPagerVC!
    
    var dimmerView:UIView!
    var currentOverlay:UIViewController?
    var overlayBottomAnchor:NSLayoutConstraint!
    var currentOverlayType:OverlayType?
    
    //var bannerView: GADBannerView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear//(hex: "171719")
        
        headerBox = UIView()
        view.addSubview(headerBox)
        headerBox.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: true)
        
        headerHeightAnchor = headerBox.heightAnchor.constraint(equalToConstant: 220)
        headerHeightAnchor.isActive = true
        
        displayView = HeaderDisplayView(item: item)
        
        headerBox.addSubview(displayView)
        displayView.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
        
        headerTopAnchor = displayView.topAnchor.constraint(equalTo: headerBox.topAnchor, constant: 0)
        headerTopAnchor.isActive = true
        
        headerBottomAnchor = displayView.bottomAnchor.constraint(equalTo: headerBox.bottomAnchor, constant: 0)
        headerBottomAnchor.isActive = true
        displayView.closeButton.addTarget(self, action: #selector(handleClose), for: .touchUpInside)
        displayView.toggleControls(true)
        
        let contentView = UIView()
        contentView.backgroundColor = UIColor(hex: "171719")
        view.addSubview(contentView)
        contentView.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: false)
        contentView.topAnchor.constraint(equalTo: headerBox.bottomAnchor).isActive = true
        
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.clear//(hex: "171719")
        contentView.addSubview(tableView)
        tableView.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: true)
        
        
        tableView.register(StockCell.self, forCellReuseIdentifier: "stockCell")
        tableView.register(StatsCell.self, forCellReuseIdentifier: "statsCell")
        tableView.register(DetailActionsCell.self, forCellReuseIdentifier: "actionsCell")
        tableView.register(DescriptionCell.self, forCellReuseIdentifier: "descriptionCell")
        tableView.register(CommentsPreviewCell.self, forCellReuseIdentifier: "commentsCell")
        tableView.register(ActionCell.self, forCellReuseIdentifier: "actionCell")
        tableView.register(AlertCell.self, forCellReuseIdentifier: "alertCell")
        tableView.register(NewsCell.self, forCellReuseIdentifier: "newsCell")
        var headerFrame = CGRect.zero
        headerFrame.size.height = .leastNormalMagnitude
        tableView.tableHeaderView = UIView(frame: headerFrame)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        tableView.reloadData()
//        detailPagerVC = DetailPagerVC()
//        detailPagerVC.item = self.item
//        detailPagerVC.willMove(toParent: self)
//        contentView.addSubview(detailPagerVC.view)
//        detailPagerVC.view.constraintToSuperview(insets: .zero, ignoreSafeArea: true)
//        self.addChild(detailPagerVC)
//        detailPagerVC.didMove(toParent: self)
//        detailPagerVC.masterDelegate = self

        
        dimmerView = UIView()
        dimmerView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(dimmerView)
        dimmerView.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: false)
        dimmerView.topAnchor.constraint(equalTo: displayView.bottomAnchor).isActive = true
        dimmerView.alpha = 0.0
        
//        adLoader = GADAdLoader(adUnitID: adUnitID, rootViewController: self,
//                               adTypes: [ .unifiedNative ], options: nil)
//        adLoader.delegate = self
//        adLoader.load(GADRequest())
        
        
        view.layoutIfNeeded()
        
        
        
        
    }
    
    let synthesizer = AVSpeechSynthesizer()
    
    func speak(text:String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
    
    var shouldSpeak = false
    
    func loop() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            if self.shouldSpeak {
                self.speak(text: "\(self.item.price)")
                self.loop()
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.addObserver(self, selector: #selector(alertsUpdated), type: .alertsUpdated)
        NotificationCenter.addObserver(self, selector: #selector(watchlistUpdated), type: .stocksUpdated)
        
        RavenAPI.getNews(forSymbols: ["AAPL", "TSLA", "AMZN"]) { news in
            self.news = news
            //self.tableView.reloadSections(IndexSet(integer: 4), with: .fade)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        shouldSpeak = true
//        speak(text: "\(item.name)")
//        speak(text: "\(item.price)")
        //loop()
        if let root = self.presentingViewController as? RootTabBarController {
            print("haha")
            root.stockBarPresent(item: item)
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MarketManager.shared.lists.removeViewer(.detail, from: item.symbol)
        NotificationCenter.default.removeObserver(self)
        shouldSpeak = false
        synthesizer.stopSpeaking(at: .immediate)
    }
    
    @objc func watchlistUpdated() {

        self.tableView.reloadData()
    }
    
    @objc func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func openPremiumVC() {
        let vc = SubscribeViewController()
        //let navVC = UINavigationController(rootViewController: vc)
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func alertsUpdated() {
        self.alerts = AlertManager.shared.alerts(for: item.symbol)
        self.tableView.reloadSections(IndexSet(integer: 1), with: .fade)
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        guard currentOverlay == nil else { return }
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else { return }
        //tableViewBottomAnchor.constant = -keyboardSize.height
        headerHeightAnchor.constant = 160
        view.layoutIfNeeded()
        
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        guard currentOverlay == nil else { return }
        //tableViewBottomAnchor.constant = 0
        headerHeightAnchor.constant = Constants.headerDisplayHeight
        view.layoutIfNeeded()
    }
    
    @objc func showActionSheet() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Add Alert", style: .default, handler: { _ in
            self.presentOverlay(.alert)
        }))
        sheet.addAction(UIAlertAction(title: "Add Position", style: .default, handler: { _ in
            
        }))
        sheet.addAction(UIAlertAction(title: "Add Note", style: .default, handler: { _ in
            
        }))
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(sheet, animated: true, completion: nil)
    }
}

extension InteractiveDetailViewController:DetailMasterDelegate {
    func presentAlertOverlay() {
        self.presentOverlay(.alert)
    }
}

extension InteractiveDetailViewController:DetailActionsDelegate {
    func detailActions(didSelect action: MarketItemAction) {
        switch action {
        case .watch:
            MarketManager.shared.toggleSubscription(to: item.symbol)
            break
        case .addAlert:
            self.presentOverlay(.alert)
            break
        case .addNote:
            break
        case .share:
            break
        }
    }
}
