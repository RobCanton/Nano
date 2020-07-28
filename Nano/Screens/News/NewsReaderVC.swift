//
//  NewsReaderVC.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-15.
//

import Foundation
import UIKit
import WebKit
import Lottie

class NewsReaderViewController:UIViewController {
    
    let news:News
    var textLabel:UILabel!
    var webView:WKWebView!
    var extract:NewsExtract?
    var tableView:UITableView!
    
    var showExtract = false
    
    var extractOnButton:UIBarButtonItem!
    var extractOffButton:UIBarButtonItem!
    var safariButton:UIBarButtonItem!
    
    var animationView:AnimationView!
    var extractingLabel:UILabel!
    
    init(news:News) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
        //self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        navigationItem.title = news.source_name
        safariButton = UIBarButtonItem(image: UIImage(systemName: "safari"), style: .plain, target: self, action: #selector(openSafari))
        extractOnButton = UIBarButtonItem(image: UIImage(systemName: "doc.text"), style: .plain, target: self, action: #selector(extractOn))
        extractOffButton = UIBarButtonItem(image: UIImage(systemName: "doc.text.fill"), style: .plain, target: self, action: #selector(extractOff))
        
        if news.type == "video" {
            navigationItem.setRightBarButtonItems([
                safariButton
            ], animated: false)
        } else {
            navigationItem.setRightBarButtonItems([
                safariButton,
                extractOnButton
            ], animated: false)
        }
        
        print("symbols: \(news.tickers ?? [])")
        
        let a = Animation.named("nano_dots")
        
        animationView = AnimationView(animation: a)
        
        view.addSubview(animationView)
        animationView.constraintToCenter(axis: [.x,.y])
        animationView.constraintWidth(to: 32)
        animationView.constraintHeight(to: 32)
        
        //animationView.tintColor = UIColor.white
        animationView.loopMode = .loop
        animationView.animationSpeed = 1.5
        animationView.alpha = 1.0
        animationView.play()
        
        extractingLabel = UILabel()
        view.addSubview(extractingLabel)
        extractingLabel.constraintToCenter(axis: [.x])
        extractingLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 6).isActive = true
        extractingLabel.text = "Extracting Article..."
        extractingLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        
//
        /// A keypath that finds the color value for all `Fill 1` nodes.
        let fillKeypath = AnimationKeypath(keypath: "**.Fill 1.Color")
        /// A Color Value provider that returns a reddish color.
        let redValueProvider = ColorValueProvider(Color(r: 1, g: 1, b: 1, a: 1))
        /// Set the provider on the animationView.
        animationView.setValueProvider(redValueProvider, keypath: fillKeypath)
        
        let fillKeypath2 = AnimationKeypath(keypath: "**.Stroke 1.Color")
        /// A Color Value provider that returns a reddish color.
        //let redValueProvider = ColorValueProvider(Color(r: 1, g: 1, b: 1, a: 1))
        /// Set the provider on the animationView.
        animationView.setValueProvider(redValueProvider, keypath: fillKeypath2)
        
        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.constraintToSuperview()
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.register(ArticleHeadlineCell.self, forCellReuseIdentifier: "headlineCell")
        tableView.register(ArticleDescriptionCell.self, forCellReuseIdentifier: "descriptionCell")
        tableView.register(ArticleBannerCell.self, forCellReuseIdentifier: "bannerCell")
        tableView.register(ArticleBodyCell.self, forCellReuseIdentifier: "bodyCell")
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.isHidden = true
        
        
        let config = WKWebViewConfiguration()
        
        webView = WKWebView(frame: view.bounds, configuration: config)
        view.addSubview(webView)
        webView.constraintToSuperview()
        let urlRequest = URLRequest(url: news.newsURL!)
        webView.load(urlRequest)
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 64, right: 0)
        
    }
    
    @objc func openSafari() {
        UIApplication.shared.open(news.newsURL!)
    }
    
    @objc func extractOn() {
        navigationItem.setRightBarButtonItems([
            safariButton,
            extractOffButton
        ], animated: true)
        
        showExtract = true
        webView.isHidden = true
        
        if extract == nil {
            RavenAPI.extractArticle(newsURL: news.newsURL!) { extract in
                self.extract = extract
                if extract == nil {
                    self.extractOff()
                    let alert = UIAlertController(title: "Extract Unavailable", message: "Sorry, there was an error when extracting this article.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.tableView.reloadData()
                    
                    UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                        self.animationView.alpha = 0.0
                        self.extractingLabel.alpha = 0.0
                    }, completion: { _ in
                        self.tableView.alpha = 0.0
                        self.tableView.isHidden = false
                        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                            self.tableView.alpha = 1.0
                        }, completion: { _ in
                            self.animationView.alpha = 1.0
                            self.extractingLabel.alpha = 1.0
                        })
                    })
                }
            }
        } else {
            self.tableView.reloadData()
            self.tableView.isHidden = false
            self.tableView.alpha = 1.0
        }
    }
    
    @objc func extractOff() {
        navigationItem.setRightBarButtonItems([
            safariButton,
            extractOnButton
        ], animated: true)
        
        showExtract = false
        
        webView.isHidden = false
        tableView.isHidden = true
    }
    
}


extension NewsReaderViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return extract?.article.description == nil ? 0 : 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let extract = self.extract else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "headlineCell", for: indexPath) as! ArticleHeadlineCell
            cell.textView.text = extract.article.headline
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! ArticleDescriptionCell
            cell.textView.text = extract.article.description
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bannerCell", for: indexPath) as! ArticleBannerCell
            if let urlStr = extract.article.mainImage,
                let url = URL(string: urlStr) {
                cell.loadURL(url)
            }
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bodyCell", for: indexPath) as! ArticleBodyCell
            cell.textView.text = extract.article.articleBody
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}
