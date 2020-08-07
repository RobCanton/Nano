//
//  SegmentedControlCell.swift
//  StockRaven
//
//  Created by Robert Canton on 2019-08-19.
//  Copyright © 2019 Robert Canton. All rights reserved.
//

import Foundation
import UIKit
import BetterSegmentedControl

protocol SegmentedControlCellDelegate:class {
    func segmentedControlCell(indexPath:IndexPath, didSelect index:Int)
}

class SegmentedControlCell:UITableViewCell {
    
    var segmentedControl:UISegmentedControl!
    
    weak var delegate:SegmentedControlCellDelegate?
    var indexPath:IndexPath?
    var stackView:UIStackView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.selectionStyle = .none
        self.backgroundColor = .systemBackground
        segmentedControl = UISegmentedControl(items: nil)
        
        contentView.addSubview(segmentedControl)
        segmentedControl.constraintToSuperview(16, 16, nil, 16, ignoreSafeArea: true)

        segmentedControl.selectedSegmentTintColor = Theme.current.primary
        /*segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white
        ], for: .selected)*/
        separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        segmentedControl.addTarget(self, action: #selector(segmentedControlDidChange), for: .valueChanged)
        
        
        stackView = UIStackView()
//        stackView.axis = .horizontal
//        stackView.distribution = .fillEqually
//        contentView.addSubview(stackView)
//        stackView.constraintToSuperview(12, 12, nil, 12, ignoreSafeArea: true)
//        stackView.constraintHeight(to: 32.0)
        
//        let control = BetterSegmentedControl(
//            frame: CGRect(x: 0, y: 0, width: 300, height: 44),
//            segments: LabelSegment.segments(withTitles: ["Price", "Bid", "Ask", "Volume"],
//                                            normalFont: UIFont.systemFont(ofSize: 14.0),
//            normalTextColor: .secondaryLabel,
//            selectedFont: UIFont.systemFont(ofSize: 14.0),
//            selectedTextColor: .label),
//            index: 1,
//            options: [.backgroundColor(UIColor.black.withAlphaComponent(0.2)),
//                      .indicatorViewBackgroundColor(.systemFill)])
//        //control.addTarget(self, action: #selector(ViewController.controlValueChanged(_:)), for: .valueChanged)
//        contentView.addSubview(control)
//        control.constraintToSuperview(12, 12, 12, 12, ignoreSafeArea: true)
//        control.constraintHeight(to: 44)
        
    }
    
    func configure(titles:[String]) {
//        for subview in stackView.arrangedSubviews {
//            subview.removeFromSuperview()
//        }
//
//        for i in 0..<titles.count {
//            let title = titles[i]
//            let button = UIButton(type: .system)
//
//            button.setTitle(title, for: .normal)
//
//            button.layer.cornerRadius = 16.0
//            //button.clipsToBounds = true
//            stackView.addArrangedSubview(button)
//
//            if i == 0 {
//                //button.backgroundColor = UIColor.systemFill
//                button.setTitleColor(.label, for: .normal)
//            } else {
//                button.backgroundColor = .clear
//                button.setTitleColor(.secondaryLabel, for: .normal)
//            }
//        }
        
    }
    
    
    @objc private func segmentedControlDidChange(_ target:UISegmentedControl) {
        guard let indexPath = indexPath else { return }
        delegate?.segmentedControlCell(indexPath: indexPath, didSelect: target.selectedSegmentIndex)
    }
    
    
    
    
}
