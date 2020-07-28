//
//  NewsPagerVC.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-16.
//

import Foundation
import UIKit
import Parchment

enum NewsType {
    case forYou
    case top
    case latest
    case trending
    case custom(topic:NewsTopic)
    
    var name:String {
        switch self {
        case .forYou:
            return "For You"
        case .top:
            return "Markets"
        case .latest:
            return "Latest"
        case .trending:
            return "Trending"
        case let .custom(topic):
            return topic.name
        }
    }
}


class NewsPagerViewController: PagingViewController {
    
    var topics:[NewsType] = [
        .forYou,
        .top,
        .trending
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for topic in NewsManager.shared.topics {
            topics.append(.custom(topic: topic))
        }
        
        //view.backgroundColor = UIColor.systemBackground
        extendedLayoutIncludesOpaqueBars = false
        edgesForExtendedLayout = []
        
        navigationItem.title = "News"
        navigationController?.navigationBar.backgroundColor = UIColor.systemBackground
        navigationController?.navigationBar.tintColor = UIColor.label
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.crop.circle"), style: .plain, target: nil, action: nil)
        
        dataSource = self
        menuItemSize = .selfSizing(estimatedWidth: 100, height: 40)
        
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
                                    insets: .zero)
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        reloadMenu()
    }
}

extension NewsPagerViewController: PagingViewControllerDataSource {
  func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
    return PagingIndexItem(index: index, title: topics[index].name)
  }
  
  func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
    return NewsViewController(type: topics[index])
  }
  
  func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
    return topics.count
  }
}

