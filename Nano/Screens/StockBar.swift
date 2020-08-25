//
//  StockBar.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-14.
//

import Foundation
import UIKit
import AudioToolbox

protocol StockBarDelegate:class {
    func stockBarDidTap(item:MarketItem)
    func stockBarDidLongPress(item:MarketItem)
}

class StockBar:UIView {
    
    weak var delegate:StockBarDelegate?
    
    weak var item:MarketItem?
  
    private(set) var stockRow:StockRow!
    
    private(set) var longPressGesture:UILongPressGestureRecognizer!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        self.addSubview(blurView)
        blurView.constraintToSuperview()
        blurView.isHidden = true
        self.backgroundColor = UIColor(hex: "171717")
        
        stockRow = StockRow()
        self.addSubview(stockRow)
        stockRow.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        self.addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(pan)
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.numberOfTouchesRequired = 1
        longPressGesture.minimumPressDuration = 0.5
        
        self.addGestureRecognizer(longPressGesture)
        
        self.isUserInteractionEnabled = true
    }
    
    func configure(item:MarketItem) {
        self.item = item
        if let item = self.item {
            MarketManager.shared.lists.addViewer(.pinbar, to: item.symbol)
        }
        self.stockRow.configure(item: item)
    }
    
    func deconfigure() {
        if let item = item {
            MarketManager.shared.lists.removeViewer(.pinbar, from: item.symbol)
        }
        self.item = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleTap() {
        print("tap!")
        guard let item = self.item else { return }
        delegate?.stockBarDidTap(item: item)
    }
    
    @objc func handlePan(_ recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)
        if translation.y < 0 {
            handleTap()
        }
        recognizer.setTranslation(.zero, in: self)
    }
    
    @objc func handleLongPress(_ recognizer:UILongPressGestureRecognizer) {
        
        guard let item = self.item else { return }
        recognizer.isEnabled = false
        AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
        //AudioServicesPlaySystemSound(1520)
        
        delegate?.stockBarDidLongPress(item: item)
    }
    
    func resetGestures() {
        longPressGesture.isEnabled = true
    }
    
}
