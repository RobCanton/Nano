//
//  DetailPagerVC.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-06.
//

import Foundation
import UIKit
import Parchment

class DetailPagerVC:PagingViewController {
    
    let titles = [
        "Data", "Comments", "Alerts", "News"
    ]
    
    weak var item:MarketItem?
    weak var masterDelegate:DetailMasterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        let menuItemWidth = UIScreen.main.bounds.width / 4
        menuItemSize = .selfSizing(estimatedWidth: menuItemWidth, height: 40)
        //menuItemSize = .fixed(width: menuItemWidth, height: 40)
        //menuInsets = .zero
        
        menuBackgroundColor = .systemBackground
        borderColor = .separator
        borderOptions = .visible(height: 0.5,
                                 zIndex: Int.max-1,
                                 insets: .zero)
        textColor = UIColor.secondaryLabel
        selectedTextColor = UIColor.label
        indicatorColor = UIColor.label
        
        indicatorOptions = .visible(height: 1,
                                    zIndex: Int.max,
                                    spacing: .zero,
                                    insets: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
        //view.backgroundColor = UIColor.systemBlue
    }
}

extension DetailPagerVC: PagingViewControllerDataSource {
  func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
    return PagingIndexItem(index: index, title: titles[index])
  }
  
  func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    guard let item = self.item else { return UIViewController() }
    switch index {
    case 0:
        return DetailDataPageVC(item: item)
    case 1:
        return DetailCommentsPageVC(item: item)
    case 2:
        return DetailAlertsPageVC(item: item, delegate: masterDelegate)
    case 3:
        break
    default:
        return UIViewController()
    }
    return NewsViewController(type: .top)
  }
  
  func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
    return titles.count
  }
}

