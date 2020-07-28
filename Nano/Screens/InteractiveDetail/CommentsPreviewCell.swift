//
//  CommentsPreviewCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-18.
//

import Foundation
import UIKit
import Firebase

class CommentsPreviewCell: UITableViewCell {
    
    private(set) var titleLabel:UILabel!
    private(set) var subtitleLabel:UILabel!
    private(set) var profileImageView:UIImageView!
    private(set) var commentLabel:UILabel!
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.systemBackground
        titleLabel = UILabel()
        contentView.addSubview(titleLabel)
        titleLabel.constraintToSuperview(12, 12, nil, nil, ignoreSafeArea: false)
        titleLabel.text = "Chat Room"
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        let peopleIcon = UIImageView()
        peopleIcon.image = UIImage(systemName: "person.2.fill")
        peopleIcon.contentMode = .scaleAspectFit
        contentView.addSubview(peopleIcon)
        peopleIcon.translatesAutoresizingMaskIntoConstraints = false
        peopleIcon.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 12.0).isActive = true
        peopleIcon.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true//lastBaselineAnchor.constraint(equalTo: titleLabel.lastBaselineAnchor).isActive = true
        peopleIcon.constraintWidth(to: 20)
        peopleIcon.constraintHeight(to: 20)
        peopleIcon.tintColor = UIColor.secondaryLabel
        
        subtitleLabel = UILabel()
        contentView.addSubview(subtitleLabel)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        //subtitleLabel.constraintToSuperview(12, nil, nil, nil, ignoreSafeArea: false)
        subtitleLabel.text = "3.2k"
        subtitleLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = .secondaryLabel
        subtitleLabel.leadingAnchor.constraint(equalTo: peopleIcon.trailingAnchor, constant: 4.0).isActive = true
        subtitleLabel.lastBaselineAnchor.constraint(equalTo: peopleIcon.lastBaselineAnchor, constant: 1).isActive = true
        
        
        profileImageView = UIImageView()
        profileImageView.backgroundColor = UIColor.systemFill
        profileImageView.contentMode = .scaleToFill
        
        contentView.addSubview(profileImageView)
        profileImageView.constraintToSuperview(nil, 12, 12, nil, ignoreSafeArea: false)
        profileImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        profileImageView.constraintWidth(to: 24)
        profileImageView.constraintHeight(to: 24)
        profileImageView.layer.cornerRadius = 24/2
        profileImageView.clipsToBounds = true
        
        
        
        
        
        commentLabel = UILabel()
        contentView.addSubview(commentLabel)
        commentLabel.constraintToSuperview(nil, nil, nil, 12, ignoreSafeArea: false)
        commentLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        commentLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8).isActive = true
        //commentLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        commentLabel.numberOfLines = 2
        commentLabel.text = "I believe you are absolutely right. There are still some deals, but some comapnies have started to run up way too much."
        commentLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        commentLabel.alpha = 0.0
    }
    
    func configure(item:MarketItem) {
        let db = Firestore.firestore()
        let ref = db.collection("comments").whereField("roomID", isEqualTo: item.symbol).order(by: "dateCreated", descending: true).limit(to: 1)
        ref.getDocuments() { querySnapshot, err in
            if let err = err {
                print("Error: \(err)")
            } else {
                
                if let document  = querySnapshot!.documents.first {
                    if let comment = Comment.parse(document.data()) {
                        
                        self.commentLabel.textColor = .label
                        self.commentLabel.text = comment.text
                        let url = comment.profile.profileImageURL
                        self.profileImageView.downloadImage(from: url)
                        self.layoutIfNeeded()
                        
                        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                            self.commentLabel.alpha = 1.0
                        }, completion: nil)
                    }
                } else {
                    self.commentLabel.textColor = .secondaryLabel
                    self.commentLabel.text = "Say something..."
                    UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                        self.commentLabel.alpha = 1.0
                    }, completion: nil)
                }
                
                
            }
        }
        
        
    }
   
    
    
    
    
}

