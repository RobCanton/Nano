//
//  NewsPreviewCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-15.
//

import Foundation
import UIKit

class NewsHeaderCell:UITableViewCell {
    
    var newsImageView:UIImageView!
    var titleLabel:UILabel!
    var bodyLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        newsImageView = UIImageView()
        contentView.addSubview(newsImageView)
        newsImageView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: true)
        //newsImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.67).isActive = true
        newsImageView.constraintHeight(to: Constants.headerDisplayHeight)
        newsImageView.backgroundColor = UIColor.secondarySystemBackground
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        
        
        
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(nil, 16, nil, 16, ignoreSafeArea: true)
        titleLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 16).isActive = true
        titleLabel.font = UIFont.systemFont(ofSize: 22.0, weight: .semibold)
//        /titleLabel.font = UIFont(name: "RobotoSlab-SemiBold", size: 22.0)
        titleLabel.numberOfLines = 0
        
        bodyLabel = UILabel()
        contentView.addSubview(bodyLabel)
        bodyLabel.constraintToSuperview(nil, 16, 16, 16, ignoreSafeArea: true)
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        bodyLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        //bodyLabel.font = UIFont(name: "RobotoSlab-Light", size: 15.0)
        bodyLabel.textColor = UIColor.secondaryLabel
        bodyLabel.numberOfLines = 0
    }
    
    func configure(news:News) {
        titleLabel.text = news.title
        bodyLabel.text = news.text
        self.newsImageView.image = nil

        if let url = news.imageURL {
            ImageManager.fetchImage(from: url) { _url, source, image in
                guard url == _url else { return }
                self.newsImageView.image = image
            }
        }
    }
}

class NewsPreviewCell:UITableViewCell {
    
    var newsImageView:UIImageView!
    var sourceLabel:UILabel!
    var titleLabel:UILabel!
    var bodyLabel:UILabel!
    var timeLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        newsImageView = UIImageView()
        contentView.addSubview(newsImageView)
        newsImageView.constraintToSuperview(16, nil, nil, 16, ignoreSafeArea: true)
        //newsImageView.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.67).isActive = true
        newsImageView.constraintHeight(to: 64)
        newsImageView.constraintWidth(to: 64)
        
        
        newsImageView.backgroundColor = UIColor.secondarySystemBackground
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        
        
        
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(16, 16, nil, nil, ignoreSafeArea: true)
        titleLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -32).isActive = true
        //titleLabel.topAnchor.constraint(equalTo: sourceLabel.bottomAnchor, constant: 8).isActive = true
        //titleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        titleLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .semibold)
        //titleLabel.font = UIFont(name: "RobotoSlab-Medium", size: 18.0)
        titleLabel.numberOfLines = 3
        
        bodyLabel = UILabel()
        contentView.addSubview(bodyLabel)
        bodyLabel.constraintToSuperview(nil, 16, nil, nil, ignoreSafeArea: true)
        bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        bodyLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -32).isActive = true
        
        bodyLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        //bodyLabel.font = UIFont(name: "RobotoSlab-Light", size: 15.0)
        bodyLabel.textColor = UIColor.secondaryLabel
        bodyLabel.numberOfLines = 2
        
        sourceLabel = UILabel()
        contentView.addSubview(sourceLabel)
        sourceLabel.constraintToSuperview(nil, 16, 16, nil, ignoreSafeArea: true)
        sourceLabel.trailingAnchor.constraint(equalTo: newsImageView.leadingAnchor, constant: -32).isActive = true
        sourceLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 8).isActive = true
        //sourceLabel.font = UIFont(name: "RobotoSlab-SemiBold", size: 14.0)
        sourceLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .semibold)
        sourceLabel.textColor = UIColor.secondaryLabel
    }
    
    func configure(news:News) {
        //sourceLabel.text = "\(news.source_name!) · 1h"
        let sourceAttributed = NSMutableAttributedString()
        sourceAttributed.append(NSAttributedString(string: news.source_name!, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ]))
        
        let dateStr = news.dateObject!.timeSinceNow()
        sourceAttributed.append(NSAttributedString(string: " · \(dateStr)", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .light),
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ]))
        sourceLabel.attributedText = sourceAttributed
        
        titleLabel.text = news.title
        bodyLabel.text = news.text
        self.newsImageView.image = nil

        if let url = news.imageURL {
            ImageManager.fetchImage(from: url) { _url, source, image in
                guard url == _url else { return }
                self.newsImageView.image = image
            }
        }
    }
}
