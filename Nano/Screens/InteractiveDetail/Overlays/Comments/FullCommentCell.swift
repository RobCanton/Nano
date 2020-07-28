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
    
    var upVoteButton = ASButtonNode()
    var votesText = ASTextNode()
    var downVoteButton = ASButtonNode()
    
    
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
        
       
        let imageConfig = UIImage.SymbolConfiguration(weight: .light)
        
        let upVoteImage = UIImage(systemName: "heart", withConfiguration: imageConfig)
        upVoteButton.setImage(upVoteImage, for: .normal)
        upVoteButton.imageNode.imageModificationBlock = { image in
            return image.mask(withColor: .secondaryLabel)
        }
        upVoteButton.setAttributedTitle(NSAttributedString(string: "2", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ]), for: .normal)
        upVoteButton.laysOutHorizontally = false
        
        let downVoteImage = UIImage(systemName: "chevron.down", withConfiguration: imageConfig)
        downVoteButton.setImage(downVoteImage, for: .normal)
        downVoteButton.imageNode.imageModificationBlock = { image in
            return image.mask(withColor: .secondaryLabel)
        }
        
        votesText.attributedText = NSAttributedString(string: "12.6k", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ])
        
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
        
        usernameNode.attributedText = NSAttributedString(string: comment.profile.username, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ])
        
        textNode.attributedText = NSAttributedString(string: comment.text, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15.0, weight: .regular),
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
        
        let actionsColumn = ASStackLayoutSpec.vertical()
        actionsColumn.children = [upVoteButton]//, downVoteButton]
        actionsColumn.justifyContent = .center
        actionsColumn.alignContent = .center
        actionsColumn.spacing = 12.0
        actionsColumn.alignItems = .center
        actionsColumn.verticalAlignment = .center
        
        let contentInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 12, left: 12 + Constants.avatarWidth + 12, bottom: 12, right: 12 + 12 + 32), child: contentStack)
        
        let columWidth:CGFloat = 12 + 32 + 12
        actionsColumn.style.width = ASDimension(unit: .points, value: 12+32+12)
        actionsColumn.style.layoutPosition = CGPoint(x: constrainedSize.max.width - columWidth,
                                                     y: 12)
        let overlayAbs = ASAbsoluteLayoutSpec(children: [actionsColumn])
        
        let overlay = ASOverlayLayoutSpec(child: contentInset, overlay: overlayAbs)
        
        avatarNode.style.layoutPosition = CGPoint(x: 12, y: 12)
        let avatarAbs = ASAbsoluteLayoutSpec(children: [avatarNode])
        let avatarOverlay = ASOverlayLayoutSpec(child: overlay, overlay: avatarAbs)
        
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

