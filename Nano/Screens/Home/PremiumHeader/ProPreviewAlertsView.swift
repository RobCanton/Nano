//
//  ProPreviewAlertsView.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-24.
//

import Foundation
import UIKit

class ProPreviewAlertsView:UIView, UITableViewDelegate, UITableViewDataSource {
    
    var tableView:UITableView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        self.constraintHeight(to: 44)
        let maxWidth = UIScreen.main.bounds.width * 0.75
        self.constraintWidth(to: UIScreen.main.bounds.width * 0.75)
        
        let contentView = UIView()
        self.addSubview(contentView)
        contentView.constraintToSuperview(0, nil, 0, nil, ignoreSafeArea: true)
        contentView.constraintWidth(to: UIScreen.main.bounds.width * 0.75)
        contentView.constraintToCenter(axis: [.x])
        
        
        let bubble = UIView()
        contentView.addSubview(bubble)
        bubble.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: true)
        bubble.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        
        bubble.applyShadow(radius: 12.0, opacity: 0.3, offset: CGSize(width: 0, height: 4.0), color: .black, shouldRasterize: false)
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = UIColor.clear
        contentView.addSubview(tableView)
        tableView.constraintToSuperview()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.isUserInteractionEnabled = false
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        cell.imageView?.image = UIImage(systemName: "arrow.up.right")
        cell.imageView?.tintColor = .white
        
        let attr = NSMutableAttributedString()
        
        attr.append(NSAttributedString(string: "AAPL", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        
        let conditionStr = " price is over "
        attr.append(NSAttributedString(string: conditionStr, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        
        var price:Double = 375.52
        if let item = MarketManager.shared.items["AAPL"] {
            price = item.price + 5.0
        }
        let priceStr =  String(format: "%.2f", locale: Locale.current, price)
        attr.append(NSAttributedString(string: priceStr, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]))
        cell.textLabel?.attributedText = attr
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
