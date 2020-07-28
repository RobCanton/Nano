//
//  StockDetailViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-04.
//

import Foundation
import UIKit

enum DetailSectionType:String {
    case alerts = "Alerts"
    case comments = "Comments"
    case notes = "Notes"
    case details = "Details"
    
    static let all = [alerts, notes, comments, details]
}

class StockDetailViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    
    var stock:Stock
    var alerts:[Alert]
    var tableView:UITableView!
    var tweets = [Tweet]()
    var news = [News]()
    var headerTabView:StockDetailTabHeader!
    
    var selectedHeaderIndex = 0
    var selectedSection:DetailSectionType {
        return DetailSectionType.all[selectedHeaderIndex]
    }
    
    init(stock:Stock) {
        self.stock = stock
        self.alerts = AlertManager.shared.alerts(for: stock.symbol)
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = stock.symbol
        view.backgroundColor = UIColor.systemBackground
        navigationItem.largeTitleDisplayMode = .never
        
        headerTabView = StockDetailTabHeader()
        headerTabView.delegate = self
        
        
        
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: true)
        tableView.delegate = self
        tableView.dataSource = self

        

        tableView.register(StockCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "addAlertCell")
        tableView.register(AlertSwitchCell.self, forCellReuseIdentifier: "alertCell")
        tableView.register(HeaderCell.self, forCellReuseIdentifier: "headerCell")
        tableView.register(TwitterCell.self, forCellReuseIdentifier: "twitterCell")
        tableView.register(NewsCell.self, forCellReuseIdentifier: "newsCell")
        //tableView.register(StockFundamentalsCell.self, forCellReuseIdentifier: "fundamentalsCell")
        //tableView.register(AlertSummaryCell.self, forCellReuseIdentifier: "alertSummaryCell")
        tableView.register(StockTitleHeaderCell.self, forCellReuseIdentifier: "titleHeaderCell")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        //tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16 + 64 + 8, right: 0)
        //tableView.separatorInset = .zero
        tableView.reloadData()
        
        /*let actionButton = JJFloatingActionButton()

        actionButton.addItem(title: nil, image: UIImage(systemName: "bell.fill")?.withRenderingMode(.alwaysTemplate)) { item in
            let alertVC = AlertViewController(stock: self.stock)
            let navVC = UINavigationController(rootViewController: alertVC)
            self.present(navVC, animated: true, completion: nil)
        }
        
        actionButton.addItem(title: nil, image: UIImage(systemName: "doc.fill")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
        }

        actionButton.addItem(title: nil, image: UIImage(systemName: "bubble.right.fill")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
        }
        
        actionButton.itemSizeRatio = CGFloat(0.8)
        actionButton.configureDefaultItem { item in

            item.buttonColor = .systemBlue
            item.buttonImageColor = .white

            item.layer.shadowColor = UIColor.black.cgColor
            item.layer.shadowOpacity = 0.3
            item.layer.shadowRadius = 8
        }
        
        actionButton.buttonDiameter = 48
        actionButton.buttonColor = UIColor.systemBlue
        actionButton.shadowRadius = 8
        actionButton.shadowColor = UIColor.black
        actionButton.shadowOpacity = 0.3
        actionButton.itemAnimationConfiguration = .circularPopUp()
        
        view.addSubview(actionButton)
        actionButton.constraintToSuperview(nil, nil, 16, 16, ignoreSafeArea: false)
        */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.addObserver(self, selector: #selector(alertsUpdated), type: .alertsUpdated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    @objc func alertsUpdated() {
        self.alerts = AlertManager.shared.alerts(for: stock.symbol)
        self.tableView.reloadData()
    }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StockCell
                //cell.configure(stock: stock)
                cell.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "fundamentalsCell", for: indexPath) as! StockFundamentalsCell
                cell.separatorInset = .zero
                return cell
            default:
                break
            }
            break
        default:
            break
        }
        return UITableViewCell()
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if offsetY >= -24 {
            if navigationItem.rightBarButtonItem == nil {
                let button = UIButton()
                button.setTitle("\(stock.trades.last?.price ?? 0)", for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
                let barButton = UIBarButtonItem(customView: button)
                navigationItem.setRightBarButton(barButton, animated: true)
            }
        } else {
            if navigationItem.rightBarButtonItem != nil {
                navigationItem.setRightBarButton(nil, animated: true)
            }
        }
    }

 
}



class HeaderCell:UITableViewCell {
    
    var titleLabel:UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        //constraintHeight(to: 32)
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(24, 16, 8, 16, ignoreSafeArea: false)
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        
        titleLabel.textColor = UIColor.secondaryLabel
    }
}
