//
//  AlertComposerView.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-10.
//

import Foundation
import UIKit

class AlertComposerView:UIView {
    
    var typeButton:UIButton!
    var conditionButton:UIButton!
    var resetButton:UIButton!
    
    var saveButton:UIButton!
    
    var pushNotificationButton:UIButton!
    var emailButton:UIButton!
    var textButton:UIButton!
    var toolBar:UIToolbar!
    var stackBottomAnchor:NSLayoutConstraint!
    var hiddenConstraintSize:CGFloat = 0
    var types = [
        "price", "bid", "ask", "volume"
    ]
    
    var selectedType = 0
    
    var stackView:UIStackView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        //self.constraintHeight(to: 48)
        self.backgroundColor = UIColor.systemBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        self.insetsLayoutMarginsFromSafeArea = false
        
        let divider = UIView()
        divider.backgroundColor = UIColor.separator

        self.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        divider.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        divider.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        stackView = UIStackView(arrangedSubviews: [])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8.0
        self.addSubview(stackView)
        stackView.constraintToSuperview(8, 8, 8, 8, ignoreSafeArea: true)
        
        
        
//        toolBar = UIToolbar()
//        toolBar.items = [
//            UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: nil),
//            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
//            UIBarButtonItem(barButtonSystemItem: .save, target: nil, action: nil)
//        ]
//        self.addSubview(toolBar)
//        toolBar.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
//        hiddenConstraintSize = 44
        //stackBottomAnchor = stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -hiddenConstraintSize)
        //stackBottomAnchor.isActive = true
        //toolBar.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 8).isActive = true
//        buildConditionRow()
//        buildDeliveryRow()
//        buildMessageRow()
//        buildResetRow()
        
        addTitleRow("New Alert")
        buildTypeRow()
        buildConditionRow()
        buildValueRow()
        addTitleRow("Send")
    }
    
    @objc func handleValueTextfield(_ textfield:UITextField) {
        
//        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
//            if textfield.hasText {
//                self.stackBottomAnchor.constant = -8
//            } else {
//                self.stackBottomAnchor.constant = 32 * 3 + 8 * 2 - self.toolBar.frame.size.height
//            }
//            self.layoutIfNeeded()
//        }, completion: nil)
    }
    
    func buildTypeRow() {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8.0
        row.constraintHeight(to: 32)
        
        let typeSeg = UISegmentedControl(items: [
            "Price", "Bid", "Ask", "Volume"
        ])
        typeSeg.selectedSegmentIndex = 0
        row.addArrangedSubview(typeSeg)
        
        stackView.addArrangedSubview(row)
    }
    
    func buildConditionRow() {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8.0
        row.constraintHeight(to: 32)
        
        let conditionSeg = UISegmentedControl(items: [
            "Is Over", "Is Under"
        ])
        conditionSeg.selectedSegmentIndex = 0
        row.addArrangedSubview(conditionSeg)
        
        stackView.addArrangedSubview(row)
    }
    
    func buildValueRow() {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8.0
        row.constraintHeight(to: 32)
        
        let valueTextfield = UITextField()
        valueTextfield.textAlignment = .center
        valueTextfield.placeholder = "1545.35"
        valueTextfield.keyboardType = .decimalPad
        valueTextfield.backgroundColor = UIColor.label.withAlphaComponent(0.08)
        valueTextfield.layer.cornerCurve = .continuous
        valueTextfield.layer.cornerRadius = 4.0
        valueTextfield.clipsToBounds = true
        valueTextfield.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        //valueTextfield.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        //valueTextfield.setContentHuggingPriority(.defaultLow, for: .horizontal)
        row.addArrangedSubview(valueTextfield)
       
        stackView.addArrangedSubview(row)
    }
    
    func addTitleRow(_ title:String) {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8.0
        row.constraintHeight(to: 32)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        
        row.addArrangedSubview(titleLabel)
       
        stackView.addArrangedSubview(row)
    }
    
    /*
    
    func buildConditionRow() {
        let topRow = UIStackView()
        topRow.axis = .horizontal
        topRow.spacing = 8.0
        topRow.constraintHeight(to: 32)
        
        let topLabel = UILabel()
        topLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        topLabel.text = "If"
        topLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        topLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        topRow.addArrangedSubview(topLabel)
        
        
        typeButton = UIButton(type: .system)
        typeButton.setTitle("price", for: .normal)
        typeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        typeButton.setTitleColor(.label, for: .normal)
        typeButton.backgroundColor = UIColor.label.withAlphaComponent(0.2)//Theme.current.primary
        typeButton.layer.cornerRadius = 4.0
        typeButton.layer.cornerCurve = .continuous
        typeButton.clipsToBounds = true
        typeButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        typeButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        typeButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        typeButton.addTarget(self, action: #selector(handleType), for: .touchUpInside)
        topRow.addArrangedSubview(typeButton)
        
        conditionButton = UIButton(type: .system)
        topRow.addArrangedSubview(conditionButton)
        conditionButton.setTitle("is over", for: .normal)
        conditionButton.tintColor = UIColor.white
        conditionButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        conditionButton.setTitleColor(.label, for: .normal)
        conditionButton.backgroundColor = UIColor.label.withAlphaComponent(0.2)//Theme.current.primary
        conditionButton.layer.cornerRadius = 4.0
        conditionButton.layer.cornerCurve = .continuous
        conditionButton.clipsToBounds = true
        conditionButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        conditionButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        conditionButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        let valueTextfield = UITextField()
        valueTextfield.textAlignment = .center
        valueTextfield.placeholder = "1542.88"
        valueTextfield.keyboardType = .decimalPad
        valueTextfield.backgroundColor = UIColor.label.withAlphaComponent(0.08)
        valueTextfield.layer.cornerCurve = .continuous
        valueTextfield.layer.cornerRadius = 4.0
        valueTextfield.clipsToBounds = true
        valueTextfield.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        valueTextfield.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        valueTextfield.setContentHuggingPriority(.defaultLow, for: .horizontal)
        valueTextfield.addTarget(self, action: #selector(handleValueTextfield), for: .editingChanged)
        topRow.addArrangedSubview(valueTextfield)
        stackView.addArrangedSubview(topRow)
    }
    
    func buildDeliveryRow() {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8.0
        row.constraintHeight(to: 32)
        
        let topLabel = UILabel()
        topLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        topLabel.text = "Send a"
        topLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        topLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        row.addArrangedSubview(topLabel)
        
        stackView.addArrangedSubview(row)
        
        pushNotificationButton = UIButton(type: .system)
        pushNotificationButton.setTitle("notification", for: .normal)
        pushNotificationButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        pushNotificationButton.setTitleColor(.label, for: .normal)
        pushNotificationButton.backgroundColor = UIColor.label.withAlphaComponent(0.2)//Theme.current.primary
        pushNotificationButton.layer.cornerRadius = 4.0
        pushNotificationButton.layer.cornerCurve = .continuous
        pushNotificationButton.clipsToBounds = true
        pushNotificationButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        row.addArrangedSubview(pushNotificationButton)
        
        emailButton = UIButton(type: .system)
        emailButton.setTitle("email", for: .normal)
        emailButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        emailButton.setTitleColor(.label, for: .normal)
        emailButton.backgroundColor = UIColor.label.withAlphaComponent(0.2)//Theme.current.primary
        emailButton.layer.cornerRadius = 4.0
        emailButton.layer.cornerCurve = .continuous
        emailButton.clipsToBounds = true
        emailButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        row.addArrangedSubview(emailButton)
        emailButton.alpha = 0.5
        
        textButton = UIButton(type: .system)
        textButton.setTitle("text message", for: .normal)
        textButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        textButton.setTitleColor(.label, for: .normal)
        textButton.backgroundColor = UIColor.label.withAlphaComponent(0.2)//Theme.current.primary
        textButton.layer.cornerRadius = 4.0
        textButton.layer.cornerCurve = .continuous
        textButton.clipsToBounds = true
        textButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        textButton.alpha = 0.5
        row.addArrangedSubview(textButton)
        
    }
    
    func buildMessageRow() {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8.0
        row.constraintHeight(to: 32)
        
        let topLabel = UILabel()
        topLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        topLabel.text = "that says"
        topLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        topLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        row.addArrangedSubview(topLabel)
        
        
        
        let valueTextfield = UITextField()
        valueTextfield.textAlignment = .center
        valueTextfield.placeholder = "nothing"
        //valueTextfield.keyboardType = .decimalPad
        valueTextfield.backgroundColor = UIColor.label.withAlphaComponent(0.08)
        valueTextfield.layer.cornerCurve = .continuous
        valueTextfield.layer.cornerRadius = 4.0
        valueTextfield.clipsToBounds = true
        valueTextfield.font = UIFont.italicSystemFont(ofSize: 14.0)
        valueTextfield.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        valueTextfield.setContentHuggingPriority(.defaultLow, for: .horizontal)
        row.addArrangedSubview(valueTextfield)
        
        stackView.addArrangedSubview(row)
        
        
    }
    
    func buildResetRow() {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 8.0
        row.constraintHeight(to: 32)
        
        let topLabel = UILabel()
        topLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        topLabel.text = "and resets"
        topLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        topLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        row.addArrangedSubview(topLabel)
        
        stackView.addArrangedSubview(row)
        
        resetButton = UIButton(type: .system)
        resetButton.setTitle("after 1 minute", for: .normal)
        resetButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        resetButton.setTitleColor(.label, for: .normal)
        resetButton.backgroundColor = UIColor.label.withAlphaComponent(0.2)//Theme.current.primary
        resetButton.layer.cornerRadius = 4.0
        resetButton.layer.cornerCurve = .continuous
        resetButton.clipsToBounds = true
        resetButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        row.addArrangedSubview(resetButton)
        
        let gapView = UIView()
        row.addArrangedSubview(gapView)
        
//        saveButton = UIButton(type: .system)
//        saveButton.setTitle("Save", for: .normal)
//        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
//        saveButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
//        saveButton.setTitleColor(Theme.current.primary, for: .normal)
//        saveButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//        saveButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        row.addArrangedSubview(saveButton)
        
        stackView.addArrangedSubview(row)
    }
    
   */
    
    
    
    @objc func handleType() {
        
        selectedType += 1
        if selectedType > types.count - 1 {
            selectedType = 0
        }
        typeButton.setTitle(types[selectedType], for: .normal)
    }
}
