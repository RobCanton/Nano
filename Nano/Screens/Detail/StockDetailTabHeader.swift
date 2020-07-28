//
//  StockDetailTabHeader.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-06.
//

import Foundation
import UIKit

protocol TabHeaderDelegate:class {
    func tabHeader(didSelect index:Int)
}

class StockDetailTabHeader:UIView {
    
    var stackView:UIStackView!
    weak var delegate:TabHeaderDelegate?
    
    var buttons = [UIButton]()
    var selectedIndex = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = UIColor.systemBackground
        stackView = UIStackView()
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.constraintToSuperview(6, 16, 2, 16, ignoreSafeArea: false)
        stackView.spacing = 4
        stackView.distribution = .fillEqually
        
        for i in 0..<DetailSectionType.all.count {
            let title = DetailSectionType.all[i].rawValue
            let button = UIButton()
            button.setTitle(title, for: .normal)
            button.sizeToFit()
            button.tag = i
            button.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
            button.setTitleColor(.label, for: .selected)
            button.setTitleColor(.secondaryLabel, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
            stackView.addArrangedSubview(button)
            
            buttons.append(button)
        }
        buttons[selectedIndex].isSelected = true
        
        let divider = UIView()
        addSubview(divider)
        divider.constraintToSuperview(nil, 16, 0, 16, ignoreSafeArea: true)
        divider.constraintHeight(to: 0.5)
        divider.backgroundColor = UIColor.separator
        
        let focusBar = UIView()
        focusBar.backgroundColor = UIColor.label
        addSubview(focusBar)
        focusBar.constraintToSuperview(nil, 16, 0, nil, ignoreSafeArea: false)
        focusBar.constraintWidth(to: (UIScreen.main.bounds.width - 32)/4)
        focusBar.constraintHeight(to: 2.0)
        
    }
    
    @objc func handleButton(_ button:UIButton) {
        buttons[selectedIndex].isSelected = false
        selectedIndex = button.tag
        buttons[selectedIndex].isSelected = true
        
        delegate?.tabHeader(didSelect: selectedIndex)
        
    }
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}

class TabButton:UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    private func setup() {
        titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        
        contentEdgeInsets = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
        //backgroundColor = UIColor.systemBlue
        layer.cornerRadius = 8
        layer.cornerCurve = .continuous
        clipsToBounds = true
        
        setBackgroundColor(color: .systemBlue, forState: .selected)
        setBackgroundColor(color: .secondarySystemFill, forState: .normal)
        setBackgroundColor(color: .systemBlue, forState: .highlighted)
        setBackgroundColor(color: .systemBlue, forState: .focused)
        
        self.addTarget(self, action: #selector(touchDown), for: .touchDown)
        self.addTarget(self, action: #selector(touchUpInside), for: .touchUpInside)
        
    }
    
    @objc func touchDown() {
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }, completion: nil)
    }
    
    @objc func touchUpInside() {
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            self.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        })
        
    }
    
    
    
}

class TagCollectionViewCell:UICollectionViewCell {
    
    var textLabel:UILabel!
    var bubbleView:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        bubbleView = UIView()
        contentView.addSubview(bubbleView)
        bubbleView.constraintToSuperview()
        
        textLabel = UILabel()
        bubbleView.addSubview(textLabel)
        textLabel.constraintToSuperview(nil, 12, nil, 12, ignoreSafeArea: true)
        textLabel.constraintToCenter(axis: [.y])
        textLabel.text = "Tech"
        textLabel.textColor = UIColor.label//Theme.current.primary
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)//monospacedSystemFont(ofSize: 13, weight: .regular)
        textLabel.textAlignment = .center
        
        bubbleView.backgroundColor = UIColor.systemFill//UIColor.label.withAlphaComponent(0.15)
        bubbleView.layer.cornerRadius = 4
        bubbleView.clipsToBounds = true
        bubbleView.layer.masksToBounds = true
        bubbleView.constraintHeight(to: 28)
        
        contentView.layer.cornerRadius = 4
        contentView.clipsToBounds = true
        contentView.layer.cornerCurve = .continuous
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
        self.layer.cornerCurve = .continuous
    }
}
