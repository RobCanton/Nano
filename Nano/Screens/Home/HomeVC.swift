//
//  HomeViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//

import Foundation
import UIKit
import SwiftUI


class HomeViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView:UITableView!
    
    var showHeader = true
    
    var searchController:UISearchController!
    var searchResultsVC:TickerSearchResultsController!
    var marketStatusView:MarketStatusView!
    
    var watchlistItems = [MarketItem]()
    var mostActiveStocksListItems = [MarketItem]()
//    var shouldHideStatusBar = false
//    override var prefersStatusBarHidden: Bool {
//        return shouldHideStatusBar
//    }
    
    @objc func handleCloseHeader() {
        showHeader = false
        tableView.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.constraintToSuperview(0, 0, 49, 0, ignoreSafeArea: true)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back",
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        
        navigationItem.setRightBarButtonItems([
            UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: self, action: #selector(openUserSettings)),
            UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(startSearch))
        ], animated: false)
        
        marketStatusView = MarketStatusView()
        let leftBarButtonItem = UIBarButtonItem(customView: marketStatusView)
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        marketStatusUpdated()
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        tableView.register(UpgradeHeaderCell.self, forCellReuseIdentifier: "upgradeCell")
        tableView.register(IndexHeaderCell.self, forCellReuseIdentifier: "indexCell")
        tableView.register(TrendingHeaderCell.self, forCellReuseIdentifier: "trendingCell")
        tableView.register(TitleCell.self, forCellReuseIdentifier: "titleCell")
        tableView.register(StockListCell.self, forCellReuseIdentifier: "listCell")
        tableView.register(StockCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        tableView.dragInteractionEnabled = true
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        stocksUpdated()
        
        getMetrics()
       
    }
    
    func getMetrics() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.getMetrics()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        stocksUpdated()
        NotificationCenter.addObserver(self, selector: #selector(marketStatusUpdated), type: .marketStatusUpdated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func startSearch() {
        let searchVC = SearchViewController()
        searchVC.modalPresentationStyle = .fullScreen
        self.present(searchVC, animated: false, completion: nil)
    }
    
    @objc func openUserSettings() {
        let settingsVC = UserSettingsViewController()
        let navVC = UINavigationController(rootViewController: settingsVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    @objc func showSideMenu() {
        NotificationCenter.post(.showSideMenu)
    }
    @objc func stocksUpdated() {
        watchlistItems = MarketManager.shared.watchlistItems
        mostActiveStocksListItems = MarketManager.shared.mostActiveStocksListItems
        self.tableView.reloadData()
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.addObserver(self, selector: #selector(stocksUpdated), type: .stocksUpdated)
        NotificationCenter.addObserver(self, selector: #selector(marketStatusUpdated), type: .marketStatusUpdated)
        
        for (_, item) in MarketManager.shared.items {
            print("Item: \(item.symbol)")
            if let stock = item as? Stock {
                print("stock: \(stock.name)")
            }
            if let forex = item as? Forex {
                print("forex: \(forex.name)")
            }
            if let crypto = item as? Crypto {
                print("crypto: \(crypto.name)")
            }
            
        }
    }
    
    @objc func marketStatusUpdated() {
        print("marketStatusUpdated")
        marketStatusView.displayStatus(MarketManager.shared.marketStatus)
    }
    
    func openStock(_ item:MarketItem) {
        let detailVC = InteractiveDetailViewController(item: item)
        detailVC.transitioningDelegate = interactiveModalTransitionDelegate
        detailVC.modalPresentationStyle = .custom
        MarketManager.shared.lists.addViewer(.detail, to: item.symbol)
        
        self.present(detailVC, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return showHeader ? 1 : 0
        }
        if section == 1 {
            return 1
        }
        return watchlistItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "upgradeCell", for: indexPath) as! UpgradeHeaderCell
            //cell.titleLabel.text = "Trending"
            cell.closeButton.addTarget(self, action: #selector(handleCloseHeader), for: .touchUpInside)
            return cell
        case 1:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "indexCell", for: indexPath) as! IndexHeaderCell
                cell.configure()
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "trendingCell", for: indexPath) as! TrendingHeaderCell
                cell.configure()
                return cell
            default:
                break
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockCell
            cell.configure(item: watchlistItems[indexPath.row])
            return cell
        default:
            break
        }
        
        return UITableViewCell()
        
    }
    
    var interactiveModalTransitionDelegate = InteractiveModalTransitionDelegate()
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section < 2 {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        openStock(watchlistItems[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 2
    }
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 2
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        MarketManager.shared.moveStock(at: sourceIndexPath.row, to: destinationIndexPath.row)
        watchlistItems = MarketManager.shared.watchlistItems
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let stock = watchlistItems[indexPath.row]
            MarketManager.shared.unsubscribe(from: stock.symbol)
            watchlistItems = MarketManager.shared.watchlistItems
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}


extension HomeViewController: UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        if indexPath.section < 2 { return [] }
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if destinationIndexPath?.section ?? 0 < 2 {
            return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
        }
        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }

        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
}

extension HomeViewController: StockListDelegate {
    func stockList(didSelect stock: Stock) {
        openStock(stock)
    }
}
