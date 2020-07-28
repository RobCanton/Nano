//
//  UserProfileSettingsCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-21.
//

import Foundation
import UIKit

class UserProfileSettingsCell:UITableViewCell {
    
    var profileImageView:UIImageView!
    var profileIconView:UIImageView!
    
    var titleStack:UIStackView!
    var usernameLabel:UILabel!
    var subtitleLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        
        accessoryType = .disclosureIndicator
        profileImageView = UIImageView()
        contentView.addSubview(profileImageView)
        profileImageView.constraintToSuperview(8, 12, 8, nil, ignoreSafeArea: true)
        profileImageView.constraintWidth(to: 64)
        profileImageView.constraintHeight(to: 64)
        profileImageView.layer.cornerRadius = 64 / 2
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .systemFill
        profileImageView.layer.borderColor = UIColor.separator.cgColor
        profileImageView.layer.borderWidth = 1
        
        profileIconView = UIImageView(image: UIImage(systemName: "camera.fill"))
        profileIconView.tintColor = UIColor.secondaryLabel
        profileIconView.contentMode = .scaleAspectFit
        profileIconView.constraintWidth(to: 32)
        profileIconView.constraintHeight(to: 32)
        contentView.addSubview(profileIconView)
        profileIconView.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor).isActive = true
        profileIconView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        titleStack = UIStackView()
        titleStack.axis = .vertical
        titleStack.spacing = 3.0
        contentView.addSubview(titleStack)
        titleStack.constraintToSuperview(nil, nil, nil, 12, ignoreSafeArea: true)
        titleStack.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12).isActive = true
        titleStack.constraintToCenter(axis: [.y])
        
        
        usernameLabel = UILabel()
        usernameLabel.text = "Replicode"
        usernameLabel.font = UIFont.systemFont(ofSize: 17.0, weight: .medium)
        
        subtitleLabel = UILabel()
        subtitleLabel.text = "View Profile"
        subtitleLabel.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        
        titleStack.addArrangedSubview(usernameLabel)
        
    }
    
    func configure() {
        subtitleLabel.removeFromSuperview()
        if let profile = UserManager.shared.userProfile {
            profileIconView.isHidden = true
            usernameLabel.text = profile.username
            titleStack.addArrangedSubview(subtitleLabel)
            ImageManager.downloadImage(from: profile.profileImageURL) { url, source, image in
                self.profileImageView.image = image
            }
        } else {
            profileIconView.isHidden = false
            profileImageView.image = nil
            usernameLabel.text = "Create Profile"
        }
    }
}
