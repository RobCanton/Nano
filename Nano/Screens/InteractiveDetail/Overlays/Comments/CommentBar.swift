//
//  CommentBar.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-29.
//

import Foundation
import UIKit

protocol CommentBarDelegate:class {
    func commentBar(didSend comment:String)
}

class CommentBar:UIView {
    
    weak var delegate:CommentBarDelegate?
   
    override var isFirstResponder: Bool {
        return textView.isFirstResponder
    }
    
    
    
    var textView:UITextView!
    var placeholderLabel:UILabel!
    var divider:UIView!
    
    var textActualHeight:CGFloat = 44
    var barHeightAnchor:NSLayoutConstraint!
    var barTrailingAnchor:NSLayoutConstraint!
    var textViewHeightAnchor:NSLayoutConstraint!
    
    var sendButton:UIButton!
    var tap:UITapGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.systemBackground
        self.translatesAutoresizingMaskIntoConstraints = false
        self.insetsLayoutMarginsFromSafeArea = false
        
        divider = UIView()
        divider.backgroundColor = UIColor.separator

        self.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        divider.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        divider.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        let textBox = UIView()
        self.addSubview(textBox)
        textBox.translatesAutoresizingMaskIntoConstraints = false
        textBox.topAnchor.constraint(equalTo: topAnchor).isActive = true
        textBox.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        textBox.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        placeholderLabel = UILabel()
        placeholderLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        placeholderLabel.text = "Add comment..."
        
        self.addSubview(placeholderLabel)
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12 + 4).isActive = true
        
        placeholderLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        placeholderLabel.constraintToCenter(axis: [.y])
        
        textView = UITextView()
        textView.tintColor = UIColor.white
        textView.keyboardType = .twitter
        textView.keyboardAppearance = .dark
        textView.isScrollEnabled = false
        textView.returnKeyType = .send
        textView.layer.cornerRadius = frame.height / 2
        textView.clipsToBounds = true
        textView.backgroundColor = UIColor.clear
        textView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        textView.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textView.textColor = UIColor.white
        textBox.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.topAnchor.constraint(equalTo: textBox.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: textBox.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: textBox.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: textBox.bottomAnchor).isActive = true

        textView.delegate = self
        textView.text = "Test"
        textView.isUserInteractionEnabled = false
        
        self.barHeightAnchor = self.heightAnchor.constraint(equalToConstant: 44)
        barHeightAnchor.isActive = true
        
        self.layoutIfNeeded()
        
        updateTextFont(textView: textView)
        placeholderLabel.text = "Say something..."
        placeholderLabel.font = textView.font
        textView.text = ""
        
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        textBox.addGestureRecognizer(tap)
    
        sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(Theme.current.primary, for: .normal)
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0, weight: .semibold)
        
        //sendButton.setImage(UIImage(named:"send"), for: .normal)
        //sendButton.setImage(UIImage(named:"send"), for: .disabled)
        sendButton.tintColor = UIColor.secondaryLabel
        sendButton.isEnabled = false
        sendButton.alpha = 0.0
        addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -18).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: self.bounds.height).isActive = true
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        textBox.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor,constant: -12).isActive = true
        self.layoutIfNeeded()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTap() {
        print("HandleTap")
        self.tap.isEnabled = false
        self.textView.isUserInteractionEnabled = true
        self.textView.becomeFirstResponder()
        
    }
    
    func keyboardWillShow() {
        
        self.sendButton.alpha = 1.0
        self.layoutIfNeeded()
    }
    
    func keyboardWillHide() {
        self.sendButton.alpha = 0.0
        self.barHeightAnchor.constant = 44
        self.textView.isUserInteractionEnabled = false
        self.tap.isEnabled = true
        self.layoutIfNeeded()
    }
    
    override func becomeFirstResponder() -> Bool {
        textView.becomeFirstResponder()
        return true
    }
    override func resignFirstResponder() -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    @objc func handleSend() {
        delegate?.commentBar(didSend: self.textView.text)
        textView.text = ""
        textViewDidChange(textView)
        let _ = resignFirstResponder()
    }
    
    
}



extension CommentBar:UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let hasText = textView.text.count > 0
        sendButton.isEnabled = hasText
        sendButton.tintColor = hasText ? Theme.current.primary : UIColor.secondaryLabel
        placeholderLabel.isHidden = hasText
        print("placeholderLabel:\(placeholderLabel.isHidden)")
        textActualHeight = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat.infinity)).height
        
        print("Height: \(textActualHeight)")
        
        barHeightAnchor.constant = textActualHeight
        self.layoutIfNeeded()
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            //delegate?.messageSend(text: textView.text)
            return false
        }
        return true
    }
    
    func updateTextFont(textView : UITextView) {
        
        
        if (textView.text.isEmpty || textView.bounds.size.equalTo(CGSize.zero)) {
            return;
        }
        
        let textViewSize = textView.frame.size;
        let fixedWidth = textViewSize.width;
        
        let expectSize = textView.sizeThatFits(CGSize(width : fixedWidth, height : CGFloat(MAXFLOAT)));
        
        var expectFont = textView.font;
        if (expectSize.height > textViewSize.height) {
            while (textView.sizeThatFits(CGSize(width : fixedWidth, height : CGFloat(MAXFLOAT))).height > textViewSize.height) {
                expectFont = textView.font!.withSize(textView.font!.pointSize - 1)
                textView.font = expectFont
            }
        }
        else {
            while (textView.sizeThatFits(CGSize(width : fixedWidth,height : CGFloat(MAXFLOAT))).height < textViewSize.height) {
                expectFont = textView.font;
                textView.font = textView.font!.withSize(textView.font!.pointSize + 1)
            }
            textView.font = expectFont;
        }
    }
}
