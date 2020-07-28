//
//  SubscribeViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-06.
//

import Foundation
import UIKit

class SubscribeViewController:UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var subscribeButton:AlertBannerView!
    var plansButton:AlertBannerView!
    var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.view.backgroundColor = UIColor.clear
        navigationController?.navigationBar.barTintColor = UIColor.clear
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationController?.navigationBar.isTranslucent = true
        //navigationItem.largeTitleDisplayMode = .always
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(handleClose))
        
        view.backgroundColor = UIColor.systemBackground
        
        title = ""
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.constraintToSuperview()
        
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.register(PremiumHeaderCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "featureCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        //tableView.isScrollEnabled = false
        tableView.isUserInteractionEnabled = false
        
        plansButton = AlertBannerView()
        plansButton.contentView.backgroundColor = UIColor.systemFill
        view.addSubview(plansButton)
        plansButton.constraintToSuperview(nil, 12, 12, 12, ignoreSafeArea: false)
        plansButton.constraintHeight(to: 52)
        plansButton.button.addTarget(self, action: #selector(purchasePremium), for: .touchUpInside)
        plansButton.isHidden = false
        plansButton.title = "See all plans"
        
        subscribeButton = AlertBannerView()
        view.addSubview(subscribeButton)
        subscribeButton.constraintToSuperview(nil, 12, nil, 12, ignoreSafeArea: false)
        subscribeButton.constraintHeight(to: 52)
        subscribeButton.button.addTarget(self, action: #selector(purchasePremium), for: .touchUpInside)
        subscribeButton.isHidden = false
        subscribeButton.title = "$7.79 / monthly"
        subscribeButton.bottomAnchor.constraint(equalTo: plansButton.topAnchor, constant: -12).isActive = true
        
    }
    
    @objc func purchasePremium() {
        print("pruchase!")
        if StoreManager.subscriptionStatus == .premium {
            StoreManager.subscriptionStatus = .free
        } else {
            StoreManager.subscriptionStatus = .premium
        }
        self.dismiss(animated: true, completion: nil)
        //StoreManager.shared.purchase(productID: Product.premiumMonthly.rawValue)
    }
    
    @objc func handleClose() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 5
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PremiumHeaderCell
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "featureCell", for: indexPath)
            cell.imageView?.tintColor = UIColor.label
            cell.selectionStyle = .none
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Unlimited Alerts"
                cell.imageView?.image = UIImage(systemName: "bell.fill")
                break
            case 1:
                cell.textLabel?.text = "Bid-Ask Display"
                cell.imageView?.image = UIImage(systemName: "arrow.right.arrow.left")
                break
            case 2:
                cell.textLabel?.text = "Candlestick Charts"
                cell.imageView?.image = UIImage(systemName: "chart.bar.fill")
                break
            case 3:
                cell.textLabel?.text = "Theme Customization"
                cell.imageView?.image = UIImage(systemName: "paintbrush.fill")
                break
            case 4:
                cell.textLabel?.text = "No ads"
                cell.imageView?.image = UIImage(systemName: "nosign")
                break
            default:
                break
            }
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class PremiumHeaderCell:UITableViewCell {
    var titleLabel:UILabel!
    var subtitleLabel:UILabel!
    var gradientView:UIView!
    var backgroundImageView:UIImageView!
    
    let headerHeight:CGFloat = Constants.headerDisplayHeight
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        backgroundImageView = UIImageView(image: UIImage(named: "blockchain"))
        contentView.addSubview(backgroundImageView)
        backgroundImageView.constraintToSuperview()
        backgroundImageView.constraintHeight(to: headerHeight)
        backgroundImageView.contentMode = .scaleAspectFill
        
        gradientView = UIView()
        contentView.addSubview(gradientView)
        gradientView.constraintToSuperview()
        
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.systemBackground.cgColor]
        gradient.locations = [0, 0.75]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        
        gradientView.layer.addSublayer(gradient)
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight + 8)
        
        subtitleLabel = UILabel()
        contentView.addSubview(subtitleLabel)
        subtitleLabel.constraintToSuperview(nil, 12, 12, 12, ignoreSafeArea: false)
        subtitleLabel.text = "Unlock all features"
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(nil, 12, nil, 12, ignoreSafeArea: false)
        titleLabel.text = "Get Premium"
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 32.0, weight: .bold)
        
        titleLabel.bottomAnchor.constraint(equalTo: subtitleLabel.topAnchor, constant: -6).isActive = true
    }
}
