//
//  SearchViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-23.
//

import Foundation
import UIKit

class SearchViewController:UIViewController {
    
    enum SearchMode {
        case stocks
        case forex
        case crypto
        
        static let all = [stocks, forex, crypto]
    }
    
    var modes = SearchMode.all
    var selectedIndex = 0
    
    var tickers = [Ticker]()
    var forexTickers = [ForexTicker]()
    var cryptoTickers = [CryptoTicker]()
    
    var closeButton:UIButton!
    var textField:UITextField!
    var segmentedControl:UISegmentedControl!
    var tableView:UITableView!
    var tableViewBottomAnchor:NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        let navView = UIView()
        view.addSubview(navView)
        navView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        navView.constraintHeight(to: 44)
        navView.backgroundColor = UIColor.systemBackground
        
        closeButton = UIButton(type: .system)
        navView.addSubview(closeButton)
        closeButton.constraintToSuperview(0, 4, 0, nil, ignoreSafeArea: true)
        closeButton.widthAnchor.constraint(equalTo: navView.heightAnchor).isActive = true
        let mediumConfig = UIImage.SymbolConfiguration(weight: .medium)
        closeButton.setImage(UIImage(systemName: "arrow.left", withConfiguration: mediumConfig), for: .normal)
        closeButton.tintColor = UIColor.label
        closeButton.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        
        textField = UITextField()
        navView.addSubview(textField)
        textField.constraintToSuperview(0, nil, 0, 12, ignoreSafeArea: true)
        textField.autocapitalizationType = .allCharacters
        textField.placeholder = "Search Stocks, Forex & Crypto"
        textField.tintColor = UIColor.label
        textField.leadingAnchor.constraint(equalTo: closeButton.trailingAnchor, constant: 6).isActive = true
        textField.addTarget(self, action: #selector(textViewDidChange), for: .editingChanged)
        
        segmentedControl = UISegmentedControl(items: ["Stocks", "Forex", "Crypto"])
        view.addSubview(segmentedControl)
        segmentedControl.constraintToSuperview(nil, 12, nil, 12, ignoreSafeArea: false)
        segmentedControl.topAnchor.constraint(equalTo: navView.bottomAnchor, constant: 4).isActive = true
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
        
        let separator = UIView()
        separator.backgroundColor = UIColor.separator
        view.addSubview(separator)
        separator.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: true)
        separator.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 12).isActive = true
        separator.constraintHeight(to: 0.5)
        
        tableView = UITableView()
        view.addSubview(tableView)
        tableView.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: false)
        tableView.topAnchor.constraint(equalTo: separator.bottomAnchor).isActive = true
        tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        tableViewBottomAnchor.isActive = true
        
        tableView.register(TickerSearchResultCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    @objc func segmentedControlDidChange() {
        self.selectedIndex = segmentedControl.selectedSegmentIndex
        self.tableView.reloadData()
        self.textViewDidChange()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleDismiss() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func textViewDidChange() {
        let text = textField.text ?? ""
        
        let mode = modes[selectedIndex]
        switch mode {
        case .stocks:
            RavenAPI.search(text) { searchFragment, tickers in
                if searchFragment != self.textField.text {
                    return
                }
                self.tickers = tickers
                self.tableView.reloadData()
            }
            break
        case .forex:
            RavenAPI.searchForex(text) { searchFragment, tickers in
                if searchFragment != self.textField.text {
                    return
                }
                self.forexTickers = tickers
                self.tableView.reloadData()
            }
            break
        case .crypto:
            RavenAPI.searchCrypto(text) { searchFragment, tickers in
                if searchFragment != self.textField.text {
                    return
                }
                self.cryptoTickers = tickers
                self.tableView.reloadData()
            }
            break
        }
        
        
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else { return }
        tableViewBottomAnchor.constant = -keyboardSize.height
        view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification:Notification) {
        view.layoutIfNeeded()
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mode = modes[selectedIndex]
        switch mode {
        case .stocks:
            return tickers.count
        case .forex:
            return forexTickers.count
        case .crypto:
            return cryptoTickers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TickerSearchResultCell
        
        let mode = modes[selectedIndex]
        let tickerDisplay:TickerProtocol
        switch mode {
        case .stocks:
            tickerDisplay = tickers[indexPath.row]
        case .forex:
            tickerDisplay = forexTickers[indexPath.row]
        case .crypto:
            tickerDisplay = cryptoTickers[indexPath.row]
        }
        cell.titleLabel.text = tickerDisplay.displayName
        cell.subtitleLabel.text = tickerDisplay.description
        cell.backgroundColor = UIColor.systemBackground
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mode = modes[selectedIndex]
        let tickerDisplay:TickerProtocol
        switch mode {
        case .stocks:
            tickerDisplay = tickers[indexPath.row]
        case .forex:
            tickerDisplay = forexTickers[indexPath.row]
        case .crypto:
            tickerDisplay = cryptoTickers[indexPath.row]
        }
        
        MarketManager.shared.subscribe(to: tickerDisplay.symbol)
        tableView.deselectRow(at: indexPath, animated: true)
        handleDismiss()
    }
}
