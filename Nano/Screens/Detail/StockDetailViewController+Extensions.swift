//
//  StockDetailViewController+Extensions.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-06.
//

import Foundation
import UIKit


extension StockDetailViewController: TabHeaderDelegate {
    func tabHeader(didSelect index: Int) {
        self.selectedHeaderIndex = index
        let sections = numberOfSections(in: self.tableView)
        self.tableView.reloadData()
        //self.tableView.reloadSections(IndexSet(1..<sections), with: .automatic)
    }
}
