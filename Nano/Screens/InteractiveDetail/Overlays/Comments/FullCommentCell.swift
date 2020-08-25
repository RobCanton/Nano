//
//  FullCommentCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-10.
//

import Foundation
import AsyncDisplayKit

class FullCommentCellNode:ASCellNode {
    
    var avatarNode = ASNetworkImageNode()
    var usernameNode = ASTextNode()
    var textNode = ASTextNode()
    var timeText = ASTextNode()

    
    
    struct Constants {
        static let avatarWidth:CGFloat = 36
    }
    override init() {
        super.init()
        //self.backgroundColor = UIColor.secondarySystemGroupedBackground
        self.automaticallyManagesSubnodes = true
        
        avatarNode.backgroundColor = UIColor.systemFill
        avatarNode.style.width = ASDimension(unit: .points, value: Constants.avatarWidth)
        
        avatarNode.style.height = ASDimension(unit: .points, value: Constants.avatarWidth)
        avatarNode.layer.cornerRadius = Constants.avatarWidth/2
        avatarNode.clipsToBounds = true
        
        
        timeText.attributedText = NSAttributedString(string: "6h", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .light),
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ])

        
    }
    
    override func didLoad() {
        super.didLoad()
        //likeButtonNode.imageNode.view.tintColor = UIColor.label
    }
    
    func setComment(_ comment:Comment) {
        
        avatarNode.url = comment.profile.profileImageURL
        
        //let titleStr = "\(comment.profile.username) · 1 hour ago"
        usernameNode.attributedText = NSAttributedString(string: comment.profile.username, attributes: [
            NSAttributedString.Key.font: UIFont.customFont(.normal, ofSize: 13.0, weight: .regular),//t.systemFont(ofSize: 13.0, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ])
        
        textNode.attributedText = NSAttributedString(string: comment.text, attributes: [
            NSAttributedString.Key.font: UIFont.customFont(.normal, ofSize: 14.0, weight: .regular),//UIFont.systemFont(ofSize: 14.0, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let textStack = ASStackLayoutSpec.vertical()
        textStack.spacing = 4.0
        textStack.children = [usernameNode, textNode]
        
        let contentStack = ASStackLayoutSpec.vertical()
        contentStack.spacing = 12.0
        contentStack.children = [textStack]
        
        let contentInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 16, left: 16 + Constants.avatarWidth + 16, bottom: 16, right: 12 + 16), child: contentStack)
      
        
        avatarNode.style.layoutPosition = CGPoint(x: 16, y: 12)
        let avatarAbs = ASAbsoluteLayoutSpec(children: [avatarNode])
        let avatarOverlay = ASOverlayLayoutSpec(child: contentInset, overlay: avatarAbs)
        
        return avatarOverlay
    }
    
    
}

class AddCommentCellNode:ASCellNode {
    
    var avatarNode = ASNetworkImageNode()
    var textNode = ASTextNode()
    
    override init() {
        super.init()
        
        self.automaticallyManagesSubnodes = true
        
        avatarNode.backgroundColor = UIColor.systemFill
        avatarNode.style.width = ASDimension(unit: .points, value: 32)
        avatarNode.style.height = ASDimension(unit: .points, value: 32)
        avatarNode.layer.cornerRadius = 32/2
        avatarNode.clipsToBounds = true
        
        textNode.attributedText = NSAttributedString(string: "Add a public comment...", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ])
        
        if let userProfile = UserManager.shared.userProfile {
            avatarNode.url = userProfile.profileImageURL
        }
    }
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
         
        self.style.height = ASDimension(unit: .points, value: 32 + 24)

        let contentInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 0, left: 12 + 32 + 8, bottom: 0, right: 12), child: textNode)
        let center = ASCenterLayoutSpec(centeringOptions: .Y, sizingOptions: .minimumY, child: contentInset)
        
        avatarNode.style.layoutPosition = CGPoint(x: 12, y: 12)
        let avatarAbs = ASAbsoluteLayoutSpec(children: [avatarNode])
        let avatarOverlay = ASOverlayLayoutSpec(child: center, overlay: avatarAbs)

        return avatarOverlay
    }
    
    override func didLoad() {
        super.didLoad()
        view.backgroundColor = UIColor.systemBackground
    }
    
}

