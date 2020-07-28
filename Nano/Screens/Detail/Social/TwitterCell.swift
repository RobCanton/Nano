//
//  TwitterCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-05.
//

import Foundation
import UIKit

class TwitterCell:UITableViewCell {
    private var stackView:UIStackView!
    private var usernameLabel:UILabel!
    private var bodyLabel:UILabel!
    private var sourceLabel:UILabel!
    
    private var profileImageView:UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        profileImageView = UIImageView()
        contentView.addSubview(profileImageView)
        profileImageView.constraintToSuperview(16, 16, nil, nil, ignoreSafeArea: false)
        profileImageView.constraintWidth(to: 32)
        profileImageView.constraintHeight(to: 32)
        profileImageView.layer.cornerRadius = 32/2
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = UIColor.systemFill
        
        stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        contentView.addSubview(stackView)
        stackView.constraintToSuperview(16, 16 + 32 + 8, 16, 16, ignoreSafeArea: false)
        
        usernameLabel = UILabel()
        usernameLabel.numberOfLines = 0
        
        bodyLabel = UILabel()
        bodyLabel.font = UIFont.italicSystemFont(ofSize: 15)//systemFont(ofSize: 15, weight: .regular)
        bodyLabel.numberOfLines = 0
        
        sourceLabel = UILabel()
        sourceLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        sourceLabel.textColor = UIColor.secondaryLabel
        
        stackView.addArrangedSubview(usernameLabel)
        stackView.addArrangedSubview(bodyLabel)
        stackView.addArrangedSubview(sourceLabel)
    }
    
    func setup(withTweet tweet:Tweet) {
        
        if let url = tweet.user.profileImageURL {
            self.profileImageView.downloadImage(from: url)
        } else {
            self.profileImageView.image = nil
        }
        
        let usernameStr = NSMutableAttributedString()
        usernameStr.append(NSAttributedString(string: tweet.user.name,
                                              attributes: [
                                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .semibold),
                                                NSAttributedString.Key.foregroundColor: UIColor.label
        ]))
        
        usernameStr.append(NSAttributedString(string: " @\(tweet.user.screen_name)",
                                              attributes: [
                                                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular),
                                                NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ]))
        
        if let date = tweet.createdAt {
            usernameStr.append(NSAttributedString(string: " · \(date.timeSinceNow())",
                                                  attributes: [
                                                    NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0, weight: .regular),
                                                    NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
            ]))
        }
        
        self.usernameLabel.attributedText = usernameStr
        self.bodyLabel.text = tweet.text
        self.sourceLabel.text = "via Twitter"
    }
    
}
