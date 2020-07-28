//
//  NewsCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-05.
//

import Foundation
import UIKit


class NewsCell:UITableViewCell {
    private var photoContainerView:UIView!
    private var photoView:UIImageView!
    private var stackView:UIStackView!
    private var sourceLabel:UILabel!
    private var titleLabel:UILabel!
    private var bodyLabel:UILabel!
    private var timeLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = .systemBackground
        
        photoContainerView = UIView()
        contentView.addSubview(photoContainerView)
        photoContainerView.constraintToSuperview(12, 12, 12, nil, ignoreSafeArea: false)
        photoContainerView.constraintWidth(to: 72)
        photoContainerView.constraintHeight(to: 72)
        photoContainerView.layer.cornerRadius = 6.0
        photoContainerView.clipsToBounds = true
        photoContainerView.backgroundColor = UIColor(hex: "171719")
        
        photoView = UIImageView()
        photoContainerView.addSubview(photoView)
        photoView.constraintToSuperview()
        photoView.contentMode = .scaleAspectFill
        
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(12, nil, nil, 12, ignoreSafeArea: false)
        
        stackView.leadingAnchor.constraint(equalTo: photoView.trailingAnchor, constant: 12).isActive = true
        
        sourceLabel = UILabel()
        sourceLabel.numberOfLines = 1
        sourceLabel.textColor = .secondaryLabel
        sourceLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .label
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        
        bodyLabel = UILabel()
        bodyLabel.numberOfLines = 1
        bodyLabel.textColor = .secondaryLabel
        bodyLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        
        timeLabel = UILabel()
        timeLabel.numberOfLines = 1
        timeLabel.textColor = .secondaryLabel
        timeLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
       
        
        
        stackView.addArrangedSubview(sourceLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bodyLabel)
        //stackView.addArrangedSubview(timeLabel)
    }
    
    func setup(withNews news:News) {
        /*
        sourceLabel.text = news.source
        titleLabel.text = news.headline
        bodyLabel.text = news.summary
        if let dateStr = news.date?.timeSinceNow() {
            timeLabel.text = dateStr
        } else {
            timeLabel.text = ""
        }
        
        photoView.image = nil
        photoView.alpha = 0.0
        if let url = URL(string: news.image) {
            print("imageURL: \(url.absoluteString)")
            
            ImageManager.fetchImage(from: url) { _url, source, image in
                if _url == url {
                    self.photoView.image = image
                    if source == .cache {
                        self.photoView.alpha = 1.0
                    } else {
                        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                            self.photoView.alpha = 1.0
                        }, completion: nil)
                    }
                    
                }
            }
        }
        */
    }
    
}

