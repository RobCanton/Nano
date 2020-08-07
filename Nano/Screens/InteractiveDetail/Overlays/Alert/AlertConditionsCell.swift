//
//  AlertConditionsCell.swift
//  Nano
//
//  Created by Robert Canton on 2020-08-03.
//  Copyright © 2020 Robert Canton. All rights reserved.
//

import Foundation
import UIKit

class AlertConditionsCell: UITableViewCell {
    
    var stackView:UIStackView!
    var typeSelector:UISegmentedControl!
    var conditionSelector:UISegmentedControl!
    var valueRow:UIStackView!
    var textField:UITextField!
    
    var minusButton:UIButton!
    var plusButton:UIButton!
    
    var typeButtons = [SelectorButton]()
    var conditionButtons = [SelectorButton]()
    
    var selectedTypeIndex = 0
    var selectedConditionIndex = 0
    
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
        stackView = UIStackView()
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(12, 12, 12, 12, ignoreSafeArea: true)
        stackView.axis = .vertical
        stackView.spacing = 12.0
        
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8.0
        stackView.addArrangedSubview(row)
        
        row.constraintHeight(to: 44)
        row.distribution = .fillEqually
        
        let buttons = [
            "Price", "Bid", "Ask", "Vol"
        ]
        
        for i in 0..<buttons.count {
            let button = SelectorButton(type: .custom)
            button.setTitle(buttons[i], for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            //button.setBackgroundColor(color: .clear, forState: .normal)
            //button.setBackgroundColor(color: .systemFill, forState: .selected)
            button.isSelected = i == selectedTypeIndex
            button.layer.cornerRadius = 3.0
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
            button.tag = i
            typeButtons.append(button)
            row.addArrangedSubview(button)
        }
        
        addDivider()
        
        let conditionsRow = UIStackView()
        conditionsRow.axis = .horizontal
        conditionsRow.spacing = 8.0
        stackView.addArrangedSubview(conditionsRow)
        
        conditionsRow.constraintHeight(to: 44)
        conditionsRow.distribution = .fillEqually
        
        let conditions = [
            "is over", "is under"
        ]
        
        for i in 0..<conditions.count {
            let button = SelectorButton(type: .custom)
            button.setTitle(conditions[i], for: .normal)
            button.setTitleColor(.label, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
            //button.setBackgroundColor(color: .clear, forState: .normal)
            //button.setBackgroundColor(color: .systemFill, forState: .selected)
            button.isSelected = i == selectedConditionIndex
            button.layer.cornerRadius = 3.0
            button.clipsToBounds = true
            button.addTarget(self, action: #selector(handleConditionButton), for: .touchUpInside)
            button.tag = i
            conditionButtons.append(button)
            conditionsRow.addArrangedSubview(button)
        }
        
        addDivider()

//
        valueRow = UIStackView()
        valueRow.axis = .horizontal
        valueRow.spacing = 12.0

        minusButton = UIButton(type: .system)
        contentView.addSubview(minusButton)
        minusButton.setTitle("-", for: .normal)
        minusButton.constraintToSuperview(16, 16, 12, nil, ignoreSafeArea: true)
        minusButton.constraintWidth(to: 64)
        minusButton.constraintHeight(to: 32)
        minusButton.backgroundColor = UIColor.systemFill
        minusButton.setTitleColor(.label, for: .normal)
        minusButton.layer.cornerRadius = 3.0
        minusButton.layer.cornerCurve = .continuous
        minusButton.clipsToBounds = true

        plusButton = UIButton(type: .system)
        contentView.addSubview(plusButton)
        plusButton.setTitle("+", for: .normal)
        plusButton.constraintToSuperview(16, nil, 12, 16, ignoreSafeArea: true)
        plusButton.constraintWidth(to: 64)
        plusButton.constraintHeight(to: 32)
        plusButton.backgroundColor = UIColor.systemFill
        plusButton.setTitleColor(.label, for: .normal)
        plusButton.layer.cornerRadius = 3.0
        plusButton.layer.cornerCurve = .continuous
        plusButton.clipsToBounds = true

        textField = UITextField()
        textField.textColor = UIColor.label
        textField.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        textField.textAlignment = .center
        textField.placeholder = "77.62"


         textField.keyboardType = .decimalPad

        valueRow.addArrangedSubview(minusButton)
        valueRow.addArrangedSubview(textField)
        valueRow.addArrangedSubview(plusButton)

        stackView.addArrangedSubview(valueRow)
        
        
    }
    
    func addDivider() {
        let divider = UIView()
        divider.constraintHeight(to: 0.5)
        divider.backgroundColor = .separator
        stackView.addArrangedSubview(divider)
    }
    
    @objc func handleButton(_ button:UIButton) {
        typeButtons[selectedTypeIndex].isSelected = false
        selectedTypeIndex = button.tag
        typeButtons[selectedTypeIndex].isSelected = true
    }
    
    @objc func handleConditionButton(_ button:UIButton) {
        conditionButtons[selectedConditionIndex].isSelected = false
        selectedConditionIndex = button.tag
        conditionButtons[selectedConditionIndex].isSelected = true
    }
}

class SelectorButton:UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
    }
    
    override var isSelected: Bool {
        didSet {
            let _isSelected = self.isSelected
                UIView.animate(withDuration: 0.3333, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.25, options: .curveEaseOut, animations: {
                    if _isSelected {
                        self.backgroundColor = Theme.current.primary//UIColor.systemFill
                        self.transform = .identity//CGAffineTransform(scaleX: 1.15, y: 1.15)
                    } else {
                        self.backgroundColor = UIColor.clear
                        self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
                    }
                }, completion: nil)
//            UIView.animate(withDuration: 0.3, animations: {
//                if _isSelected {
//                    self.backgroundColor = Theme.current.primary//UIColor.systemFill
//                } else {
//                    self.backgroundColor = UIColor.clear
//                }
//            })
        }
    }
}

