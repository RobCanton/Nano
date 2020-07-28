//
//  TickerSearchResultsController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-02.
//

import Foundation
import UIKit

protocol TickerSearchDelegate {
    func tickerSearch(didSelect ticker:Ticker)
}

class TickerSearchResultsController: UITableViewController, UISearchBarDelegate {
    
    var tickers = [Ticker]()
    
    var delegate:TickerSearchDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        tableView.register(TickerSearchResultCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        RavenAPI.search(searchText) { searchFragment, tickers in
            if searchFragment != searchBar.text {
                return
            }
            self.tickers = tickers
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TickerSearchResultCell
        let ticker = tickers[indexPath.row]
        cell.titleLabel.text = ticker.symbol
        cell.subtitleLabel.text = "\(ticker.securityName) [\(ticker.exchange)]"
        cell.backgroundColor = UIColor.systemBackground
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ticker = tickers[indexPath.row]
        delegate?.tickerSearch(didSelect: ticker)
        tableView.deselectRow(at: indexPath, animated: true)
        //self.dismiss(animated: true, completion: nil)
    }
    
//    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
//        switch selectedScope {
//        case <#pattern#>:
//            <#code#>
//        default:
//            <#code#>
//        }
//    }
 
}

class TickerSearchResultCell: UITableViewCell {
    
    var titleLabel:UILabel!
    var subtitleLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor(hex: "1D1D1E")
        
        titleLabel = UILabel()
        titleLabel.font = .monospacedSystemFont(ofSize: 18, weight: .medium)//.systemFont(ofSize: 18.0, weight: .medium)
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(nil, 16, nil, nil, ignoreSafeArea: true)
        titleLabel.constraintToCenter(axis: [.y])
        
        subtitleLabel = UILabel()
        subtitleLabel.font = .monospacedSystemFont(ofSize: 12, weight: .regular)//.systemFont(ofSize: 12.0, weight: .regular)
        subtitleLabel.textColor = UIColor.secondaryLabel
        contentView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor).isActive = true
        subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12).isActive = true
        subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16).isActive = true
        subtitleLabel.textAlignment = .left
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        subtitleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        subtitleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
    }
    
}
