//
//  DetailPageVC+Data.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-06.
//

import UIKit

class DetailDataPageVC:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let item:MarketItem
    var trades = [MarketTrade]()
    
    init(item:MarketItem) {
        self.item = item
        self.trades = item.displayTrades.reversed()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var isScrolling = false
    var quoteView:QuoteView!
    
    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        
        let quoteHeader = UIView()
        view.addSubview(quoteHeader)
        quoteHeader.constraintToSuperview(16, 12, nil, 12, ignoreSafeArea: true)
        
        let bidLabel = UILabel()
        quoteHeader.addSubview(bidLabel)
        bidLabel.constraintToSuperview(0, 0, 0, nil, ignoreSafeArea: true)
        bidLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        bidLabel.text = "Bid"
        
        let askLabel = UILabel()
        quoteHeader.addSubview(askLabel)
        askLabel.constraintToSuperview(0, nil, 0, 0, ignoreSafeArea: true)
        askLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        askLabel.text = "Ask"
        askLabel.textColor = UIColor.secondaryLabel
        
        
        quoteView = QuoteView()
        view.addSubview(quoteView)
        quoteView.constraintToSuperview(nil, 12, nil, 12, ignoreSafeArea: true)
        quoteView.topAnchor.constraint(equalTo: quoteHeader.bottomAnchor, constant: 8).isActive = true
        quoteView.configure(item: item)
        
        let divider = UIView()
        view.addSubview(divider)
        divider.topAnchor.constraint(equalTo: quoteView.bottomAnchor, constant: 12).isActive = true
        divider.constraintToSuperview(nil, 12, nil, 12, ignoreSafeArea: true)
        divider.constraintHeight(to: 0.5)
        divider.backgroundColor = UIColor.separator
        
        
        tableView = UITableView()
        view.insertSubview(tableView, belowSubview: divider)
        tableView.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: false)
        tableView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 0).isActive = true
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        tableView.register(StatsCell.self, forCellReuseIdentifier: "statsCell")
        tableView.register(DetailQuoteViewCell.self, forCellReuseIdentifier: "quoteCell")
        tableView.register(DetailTradeCell.self, forCellReuseIdentifier: "tradeCell")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       NotificationCenter.addObserver(self, selector: #selector(reloadTrades), type: .stockTradeUpdated(item.symbol))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func reloadTrades() {
        guard !isScrolling else { return }
        let diff = item.displayTrades.count - self.trades.count
        //guard diff > 0 else { return }
        
        
        let length = min(12, item.displayTrades.count)
        let start = item.displayTrades.count - length
        self.trades = item.displayTrades.reversed()//Array(item.displayTrades[start..<item.displayTrades.count]).reversed()
        self.tableView.reloadData()
//        if diff > 0 {
//            let indexPaths = (0..<diff).map { i in
//                return IndexPath(row: i, section: 3)
//            }
//            self.tableView.insertRows(at: indexPaths, with: .fade)
//        } else {
//
//        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return trades.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "statsCell", for: indexPath) as! StatsCell
//            cell.configure(item: item)
//            cell.separatorInset = .zero
//            return cell
//        } else if indexPath.section == 1 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "quoteCell", for: indexPath) as! DetailQuoteViewCell
//            cell.configure(item: item)
//            return cell
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tradeCell", for: indexPath) as! DetailTradeCell
            cell.defaultHeader()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "tradeCell", for: indexPath) as! DetailTradeCell
            let trade = trades[indexPath.row]//[(trades.count-1) - indexPath.row]
            cell.configure(trade: trade)
//
//            if indexPath.count < trades.count {
////                let prevTrade = trades[(trades.count-1) - indexPath.row - 1]
////                if trade.p > prevTrade.p {
////                    cell.priceLabel.textColor = Theme.current.positive
////                } else if trade.p < prevTrade.p {
////                    cell.priceLabel.textColor = Theme.current.negative
////                } else {
////                    cell.priceLabel.textColor = UIColor.label
////                }
//            } else {
//                cell.priceLabel.textColor = UIColor.label
//            }
            
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //isScrolling = true
        if scrollView.contentOffset.y > 0 {
            isScrolling = true
        }
        //isScrolling = true//scrollView.contentOffset.y > 0
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            isScrolling = false
        }
    }
    
    
    
}
