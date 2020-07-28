//
//  HomeViewController+ContextMenu.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-23.
//

import Foundation
import UIKit

extension HomeViewController {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPath.section == 3 else { return nil }
        let item = watchlistItems[indexPath.row]
            
            
        return UIContextMenuConfiguration(identifier: NSString(string: item.symbol),
                                              previewProvider: nil,
                                              actionProvider: { [weak self] _ in
                return self?.makeContextMenu(item: item)
            })
        }
        
        private func makeContextMenu(item:MarketItem) -> UIMenu {

            var menuElements = [UIMenuElement]()
            
            let pin = UIAction(title: "Pin",
                               image: UIImage(systemName: "pin")) { _ in

                                NotificationCenter.post(.pinStock, userInfo: [
                                    "item": item
                                ])
            }
            
            menuElements.append(pin)
            
            let addAlert = UIAction(title: "Add Alert",
                               image: UIImage(systemName: "bell")) { _ in
            }
            
            menuElements.append(addAlert)
            
            let addPosition = UIAction(title: "Add Position",
                               image: UIImage(systemName: "mappin.and.ellipse")) { _ in
            }
            
            menuElements.append(addPosition)
            
            
            let addNote = UIAction(title: "Add Note",
                               image: UIImage(systemName: "doc")) { _ in
            }
            
            menuElements.append(addNote)
            
           
            
          return UIMenu(title: "",
                        image: nil,
                        identifier: nil,
                        children: menuElements)
        }
        
        func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
            
            guard let identifier = configuration.identifier as? String else { return nil }
            guard let index = watchlistItems.firstIndex(where: { t in
                return t.symbol == identifier
            }) else { return nil }
            
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 3)) as? StockCell else { return nil }
            
            let parameters = UIPreviewParameters()
    //        /parameters.backgroundColor = cell.contentView.backgroundColor
            //parameters.backgroundColor = .clear
            
            return UITargetedPreview(view: cell.contentView, parameters: parameters)
        }
        
        func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
            print("willPerformPreviewActionForMenuWith")
        }

        
        
        func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
             guard let identifier = configuration.identifier as? String else { return nil }
            guard let index = watchlistItems.firstIndex(where: { t in
                   return t.symbol == identifier
               }) else { return nil }
               
               guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 3)) as? StockCell else { return nil }
                
                tableView.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
               
               let parameters = UIPreviewParameters()
               //parameters.backgroundColor = .clear
               
               return UITargetedPreview(view: cell.contentView, parameters: parameters)
        }
}
