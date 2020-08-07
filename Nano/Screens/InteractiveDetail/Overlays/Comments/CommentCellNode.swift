//
//  CommentCellNode.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-03.
//

import Foundation
import AsyncDisplayKit


class CommentCellNode:ASCellNode {
    
    var avatarNode = ASNetworkImageNode()
    var usernameNode = ASTextNode()
    var textNode = ASTextNode()
    var timeText = ASTextNode()
    
    struct Constants {
        static let avatarWidth:CGFloat = 32
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
        
    }
    
    override func didLoad() {
        super.didLoad()
        //likeButtonNode.imageNode.view.tintColor = UIColor.label
    }
    
    func setComment(_ comment:Comment) {
        
        avatarNode.url = comment.profile.profileImageURL
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm: a"
        
        let timeStr = dateFormatter.string(from: comment.dateCreated)

        let bodyStr = NSMutableAttributedString()
        
        
        bodyStr.append(NSAttributedString(string: timeStr, attributes: [
            
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11.0, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel,
            NSAttributedString.Key.baselineOffset: 0.5
            
        ]))
        
        bodyStr.append(NSAttributedString(string: "   \(comment.profile.username)   ", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ]))
        
        bodyStr.append(NSAttributedString(string: comment.text, attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]))
        
        bodyStr.append(NSAttributedString(string: "   ", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0, weight: .medium),
            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
        ]))
        
//        bodyStr.append(NSAttributedString(string: "  Bullish  ", attributes: [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0, weight: .regular),
//            NSAttributedString.Key.foregroundColor: Theme.current.positive,
//            NSAttributedString.Key.backgroundColor: Theme.current.positive.withAlphaComponent(0.2)
//        ]))

        
        textNode.attributedText = bodyStr
//        usernameNode.attributedText = NSAttributedString(string: comment.profile.username, attributes: [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .medium),
//            NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel
//        ])
//
//        textNode.attributedText = NSAttributedString(string: comment.text, attributes: [
//            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
//            NSAttributedString.Key.foregroundColor: UIColor.label
//        ])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
//        let textStack = ASStackLayoutSpec.vertical()
//        textStack.spacing = 4.0
//        textStack.children = [usernameNode, textNode]
//
        //self.style.minHeight = ASDimension(unit: .points, value: 32 + 16)
        let contentInset = ASInsetLayoutSpec(insets: UIEdgeInsets(top: 13, left: 12 + Constants.avatarWidth + 8, bottom: 13, right: 12),
                                             child: textNode)
        
        avatarNode.style.layoutPosition = CGPoint(x: 12, y: 5)
        let avatarAbs = ASAbsoluteLayoutSpec(children: [avatarNode])
        let avatarOverlay = ASOverlayLayoutSpec(child: contentInset, overlay: avatarAbs)
        
        return avatarOverlay
    }
    
    
}

class MyTextView: UITextView {

    let textViewPadding: CGFloat = 7.0

    override func draw(_ rect: CGRect) {
        self.layoutManager.enumerateLineFragments(forGlyphRange: NSMakeRange(0, self.text.count)) { (rect, usedRect, textContainer, glyphRange, Bool) in

            let rect = CGRect(x: usedRect.origin.x, y: usedRect.origin.y + self.textViewPadding, width: usedRect.size.width, height: usedRect.size.height*1.2)
            let rectanglePath = UIBezierPath(roundedRect: rect, cornerRadius: 3)
            UIColor.red.setFill()
            rectanglePath.fill()
        }
    }
}
