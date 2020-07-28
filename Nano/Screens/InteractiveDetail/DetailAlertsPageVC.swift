//
//  DetailAlertsPageVC.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-07.
//

import UIKit

class DetailAlertsPageVC:UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let item:MarketItem
    weak var delegate:DetailMasterDelegate?
    init(item:MarketItem, delegate:DetailMasterDelegate?=nil) {
        self.item = item
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var composerBar:AlertComposerView!
    var composerBottomAnchor:NSLayoutConstraint!
    
    var tableView:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = UITableView(frame: view.bounds, style: .grouped)
        view.addSubview(tableView)
        tableView.constraintToSuperview()
        
        tableView.register(ActionCell.self, forCellReuseIdentifier: "actionCell")
        tableView.register(StatsCell.self, forCellReuseIdentifier: "statsCell")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
        composerBar = AlertComposerView()

        view.addSubview(composerBar)
        composerBar.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: false)
        composerBottomAnchor = composerBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        composerBottomAnchor.isActive = true
        
//        let button = UIButton(type: .system)
//        view.addSubview(button)
//        button.constraintToSuperview(nil, 12, 12, nil, ignoreSafeArea: false)
//        //button.constraintHeight(to: 52)
//        button.setTitle("New Alert", for: .normal)
//        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
//        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -12)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
//        button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        //button.backgroundColor = UIColor.systemFill
        
//        let button = AlertBannerView()
//        button.title = "Add Alert"
//        view.addSubview(button)
//        button.constraintToSuperview(nil, 12, 12, 12, ignoreSafeArea: false)
//        button.constraintHeight(to: 44)
//        button.button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
    }
    
    @objc func handleButton() {
        self.delegate?.presentAlertOverlay()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else { return }
        //tableViewBottomAnchor.constant = -keyboardSize.height
        composerBottomAnchor.constant = -(keyboardSize.height)
        view.layoutIfNeeded()
    }
        
    @objc func keyboardWillHide(notification:Notification) {
        
        composerBottomAnchor.constant = 0//commentBar.bounds.height
        view.layoutIfNeeded()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell", for: indexPath) as! ActionCell
        cell.textLabel?.text = "Add Alert"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.presentAlertOverlay()
    }
    
}
