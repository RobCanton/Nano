//
//  ArticleBodyCell.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-17.
//

import Foundation
import UIKit

class ArticleHeadlineCell:UITableViewCell {
    var textView:UITextView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        textView = UITextView()
        contentView.addSubview(textView)
        textView.constraintToSuperview(12, 12, 8, 12, ignoreSafeArea: true)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        textView.textContainerInset = .zero
    }
}

class ArticleDescriptionCell:UITableViewCell {
    var textView:UITextView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        textView = UITextView()
        textView.textContainerInset = .zero
        contentView.addSubview(textView)
        textView.constraintToSuperview(0, 12, 16, 12, ignoreSafeArea: true)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 17, weight: .light)
    }
}

class ArticleBannerCell:UITableViewCell {
    var bannerImageView:UIImageView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        bannerImageView = UIImageView()
        contentView.addSubview(bannerImageView)
        bannerImageView.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: true)
        bannerImageView.contentMode = .scaleAspectFill
        bannerImageView.constraintHeight(to: Constants.headerDisplayHeight)
        bannerImageView.clipsToBounds = true
        bannerImageView.backgroundColor = UIColor.secondarySystemGroupedBackground
    }
    
    func loadURL(_ url:URL) {
        ImageManager.fetchImage(from: url) { url, source, image in
            self.bannerImageView.image = image
        }
    }
}


class ArticleBodyCell:UITableViewCell {
    var textView:UITextView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        textView = UITextView()
        textView.textContainerInset = .zero
        contentView.addSubview(textView)
        textView.constraintToSuperview(16, 12, 16, 12, ignoreSafeArea: true)
        textView.isScrollEnabled = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 17, weight: .light)
    }
}
