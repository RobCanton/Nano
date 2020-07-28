//
//  StockDetailPageViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-07.
//

import Foundation
import UIKit

class StockDetailPageViewController: UIPageViewController {

    var stocks:[Stock] {
        return []//MarketManager.shared.stocks
    }
    var startIndex:Int
    init(startIndex:Int = 0) {
        self.startIndex = startIndex
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        var vcs = [UIViewController]()
        for stock in self.stocks {
            let stockVC = StockDetailViewController(stock: stock)
            vcs.append(stockVC)
        }
        return vcs
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = stocks[startIndex].symbol
        navigationItem.largeTitleDisplayMode = .never
        
        dataSource = self
        delegate = self
        
        let startViewController = orderedViewControllers[startIndex]
        setViewControllers([startViewController],
            direction: .forward,
            animated: true,
            completion: nil)
        
    }
}

extension StockDetailPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }

        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }

        guard orderedViewControllers.count > previousIndex else {
            return nil
        }

        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.firstIndex(of: viewController) else { return nil }

        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }

        guard orderedViewControllersCount > nextIndex else {
            return nil
        }

        return orderedViewControllers[nextIndex]
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        print("current: \(offsetX)")
        
        
    }
    
    
}
