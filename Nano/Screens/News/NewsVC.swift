//
//  NewsVC.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-15.
//

import Foundation
import UIKit

class NewsViewController:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let type:NewsType
    var news = [News]()
    var tableView:UITableView!
    
    init(type:NewsType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        
        navigationItem.title = "News"
        navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationController?.navigationBar.isTranslucent = false
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.constraintToSuperview()
        tableView.register(NewsHeaderCell.self, forCellReuseIdentifier: "headerCell")
        tableView.register(NewsPreviewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        tableView.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch type {
        case .forYou:
            let symbols = MarketManager.shared.lists.watchlist
            
            RavenAPI.getNews(forSymbols: symbols) { news in
                self.news = news
                self.tableView.reloadData()
            }
            break
        case .top:
            RavenAPI.getMarketNews { news in
                self.news = news
                self.tableView.reloadData()
            }
            break
        case .trending:
            let symbols = MarketManager.shared.lists.mostActiveStocks
            RavenAPI.getNews(forSymbols: symbols) { news in
                self.news = news
                self.tableView.reloadData()
            }
            break
        case let .custom(topic):
            RavenAPI.getNews(forTopic: topic) { news in
                self.news = news
                self.tableView.reloadData()
            }
            break
        default:
            break
        }
        
    }
    
    /*
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.blue
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 52
    }*/
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath) as! NewsHeaderCell
            cell.configure(news: news[indexPath.row])
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NewsPreviewCell
        cell.configure(news: news[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let readerVC = NewsReaderViewController(news: news[indexPath.row])
        self.navigationController?.pushViewController(readerVC, animated: true)
    }
}
