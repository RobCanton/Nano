//
//  MarketDataVC.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-17.
//

import Foundation
import UIKit
import Lottie

class MarketDataViewController:UIViewController {
    
    var tableView:UITableView!
    var animationView:AnimationView!
    var mostActiveStocks = [Stock]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        navigationItem.title = "Market Data"
        
        let a = Animation.named("nano_dots")
        
        animationView = AnimationView(animation: a)
        
        view.addSubview(animationView)
        animationView.constraintToCenter(axis: [.x,.y])
        animationView.constraintWidth(to: 32)
        animationView.constraintHeight(to: 32)
        
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        animationView.alpha = 1.0
        animationView.play()
        
        let fillKeypath = AnimationKeypath(keypath: "**.Fill 1.Color")
        let colorValueProvider = ColorValueProvider(Color(r: 1, g: 1, b: 1, a: 1))
        animationView.setValueProvider(colorValueProvider, keypath: fillKeypath)
        let fillKeypath2 = AnimationKeypath(keypath: "**.Stroke 1.Color")
        animationView.setValueProvider(colorValueProvider, keypath: fillKeypath2)
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.constraintToSuperview()
        tableView.register(StockListCell.self, forCellReuseIdentifier: "listCell")
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.alpha = 0.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        RavenAPI.getMarketData { _mostActiveStocks in
            self.mostActiveStocks = _mostActiveStocks
            self.tableView.reloadData()
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                self.animationView.alpha = 0.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                    self.tableView.alpha = 1.0
                })
            })
        }
    }
}

extension MarketDataViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath) as! StockListCell
        cell.configure(list: mostActiveStocks)
        
        return cell
    }
}
