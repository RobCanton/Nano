//
//  PremiumHeaderCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-23.
//

import Foundation
import UIKit
import MKGradientView

class UpgradeHeaderCell:UITableViewCell {
    
    var closeButton:UIButton!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        self.clipsToBounds = true
        let gradientView = GradientView(frame: CGRect(x: 100, y: 0, width: 100, height: 100))
        gradientView.type = .bilinear
        gradientView.colors = [
            UIColor.systemPink,
            Theme.current.positive
        ]
        gradientView.layer.contentsScale = 0.25//UIScreen.main.scale
        gradientView.colors2 = [
            UIColor.systemBlue,
            UIColor.cyan
        ]
        gradientView.locations = [0.0, 1.0]
        gradientView.locations2 = [0.0, 1.0]
        
        contentView.addSubview(gradientView)
        gradientView.constraintToSuperview(-16, -16, -16, -16, ignoreSafeArea: true)
        
        closeButton = UIButton(type: .custom)
        closeButton.setImage(UIImage(named: "close_small"), for: .normal)
        contentView.addSubview(closeButton)
        closeButton.constraintToSuperview(12, nil, nil, 12, ignoreSafeArea: true)
        closeButton.tintColor = .white
        //closeButton.isHidden = true
        
        let titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(12, 12, nil, nil, ignoreSafeArea: true)
        titleLabel.text = "Unlock Pro Features"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.textColor = .white
        
        let priceLabel = UILabel()
        contentView.addSubview(priceLabel)
        priceLabel.constraintToSuperview(nil, 12, nil, nil, ignoreSafeArea: true)
        priceLabel.text = "12.79 CAD / month"
        priceLabel.textColor = .white
        priceLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)//UIFont.monospacedSystemFont(ofSize: 20, weight: .bold)
        priceLabel.textAlignment = .right
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
        //priceLabel.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 8).isActive = true
        //priceLabel.lastBaselineAnchor.constraint(equalTo: label.lastBaselineAnchor).isActive = true
        
        let previewView = ProPeviewView()
        contentView.addSubview(previewView)
        previewView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16).isActive = true
        previewView.constraintToSuperview(nil, 12, 16, 12, ignoreSafeArea: true)
        
        /*
        let detailView = UIStackView()
        detailView.axis = .vertical
        detailView.spacing = 12.0
        contentView.addSubview(detailView)
        detailView.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 16).isActive = true
        detailView.constraintToSuperview(nil, 12, 16, 12, ignoreSafeArea: true)
        
        let titleLabel = UILabel()
        titleLabel.text = "real-time tick-level charts & prices*"
        titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        let previewView = ProPreviewPricesView()
        //detailView.addArrangedSubview(previewView)
        
        //detailView.addArrangedSubview(titleLabel)
        
        let previewRow = UIView()
        previewRow.addSubview(previewView)
        previewView.constraintToSuperview(0, nil, 0, nil, ignoreSafeArea: true)
        previewView.constraintToCenter(axis: [.x])
        detailView.addArrangedSubview(previewRow)
        detailView.addArrangedSubview(titleLabel)
        
        let divider = UIView()
        contentView.addSubview(divider)
        divider.constraintHeight(to: 0.5)
        divider.backgroundColor = .separator
        divider.constraintToSuperview(nil, 0, 0, 0, ignoreSafeArea: true)*/
        
        
    }
    
    
    
}

class ProPeviewView:UIView {
    
    var stackView:UIStackView!
    var previewRow:UIView!
    var captionLabel:UILabel!
    var previewPricesView:ProPreviewPricesView!
    var previewBidAskView:ProPreviewBidAskView!
    var previewAlertsView:ProPreviewAlertsView!
    enum Feature {
        case prices
        case quotes
        case alerts
        
        static let all = [prices, quotes, alerts]
        
        var captionStr:String {
            switch self {
            case .prices:
                return "real-time tick-level charts & trades*"
            case .quotes:
                return "bid-ask comparison chart"
            case .alerts:
                return "unlimited alerts checked every second"
            }
        }
    }
    
    var index = 0
    var currentFeature:Feature {
        return Feature.all[index]
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12.0
        self.addSubview(stackView)
        stackView.constraintToSuperview()
        
        
        captionLabel = UILabel()
        captionLabel.text = "real-time tick-level charts & trades*"
        captionLabel.textColor = .white
        captionLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        captionLabel.textAlignment = .center
        captionLabel.numberOfLines = 0
        stackView.addArrangedSubview(captionLabel)
        
        previewPricesView = ProPreviewPricesView()
        previewBidAskView = ProPreviewBidAskView()
        previewAlertsView = ProPreviewAlertsView()
        
        displayCurrentFeature()
        
        let _ = Timer.scheduledTimer(timeInterval: 7.5, target: self, selector: #selector(self.animateNext), userInfo: nil, repeats: true)
        
    }
    
    @objc func animateNext() {
        index += 1
        if index >= Feature.all.count {
            index = 1
        }
        
        UIView.animate(withDuration: 0.45, delay: 0.0, options: .curveEaseOut, animations: {
            self.stackView.alpha = 0.0
        }, completion: { _ in
            self.clearCurrentFeature()
            self.displayCurrentFeature()
            
            UIView.animate(withDuration: 0.45, delay: 0.0, options: .curveEaseIn, animations: {
                self.stackView.alpha = 1.0
            }, completion: { _ in
                
            })
            
        })
    }
    
    func displayCurrentFeature() {
        
        let feature = currentFeature
        captionLabel.text = feature.captionStr
        switch feature {
        case .prices:
            stackView.insertArrangedSubview(previewPricesView, at: 0)
            break
        case .quotes:
            stackView.insertArrangedSubview(previewBidAskView, at: 0)
            break
        case .alerts:
            stackView.insertArrangedSubview(previewAlertsView, at: 0)
            break
        }
    }
    
    func clearCurrentFeature() {
        previewPricesView.removeFromSuperview()
        previewBidAskView.removeFromSuperview()
        previewAlertsView.removeFromSuperview()
    }
}
