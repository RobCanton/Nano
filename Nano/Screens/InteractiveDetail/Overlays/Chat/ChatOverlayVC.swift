//
//  ChatOverlayViewController.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-05-20.
//

import Foundation
import UIKit
import AsyncDisplayKit
import Firebase
/*
class ChatOverlayViewController:OverlayViewController {
    
    let stock:Stock
    
    init(stock:Stock) {
        self.stock = stock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var tableNode = ASTableNode()
    var tableView:UITableView {
        return tableNode.view
    }
    var commentBar:CommentBar!
    var commentBottomAnchor:NSLayoutConstraint!
    
    var joinButton:AlertBannerView!
    
    var comments = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Comments", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleDismiss))
        
        navigationController?.navigationBar.tintColor = UIColor.label
        
        commentBar = CommentBar()
        commentBar.delegate = self
        
        contentView.addSubview(commentBar)
        commentBar.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: false)
        commentBottomAnchor = commentBar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        commentBottomAnchor.isActive = true
        
        contentView.insertSubview(tableView, at: 0)
        tableView.constraintToSuperview(0, 0, 0, 0, ignoreSafeArea: false)
        //tableView.bottomAnchor.constraint(equalTo: commentBar.topAnchor).isActive = true
        //tableView.keyboardDismissMode = .interactive
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.separatorStyle = .none
        //tableView.separatorInset = .zero
        tableView.showsVerticalScrollIndicator = false
        
        //tableNode.inverted = true
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.reloadData()
        
        
        
        joinButton = AlertBannerView()
        view.addSubview(joinButton)
        joinButton.constraintToSuperview(nil, 12, 12, 12, ignoreSafeArea: false)
        joinButton.constraintHeight(to: 52)
        joinButton.button.addTarget(self, action: #selector(openCreateProfile), for: .touchUpInside)
        joinButton.isHidden = true
        joinButton.title = "Join the conversation"
        
        displayJoinIfNeeded()
        
        commentBottomAnchor.constant = commentBar.bounds.height
        view.layoutIfNeeded()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        observeComments()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        stopObservingComments()
    }
    
    func observeComments() {
        
        let db = Firestore.firestore()
        let ref = db.collection("comments").whereField("roomID", isEqualTo: stock.symbol)
        
        ref.addSnapshotListener{ snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                
                var newComments = [Comment]()
                for document in snapshot!.documentChanges {
                    switch document.type {
                    case .added:
                        if let comment = Comment.parse(document.document.data()) {
                            newComments.insert(comment, at: 0)
                        }
                        break
                    default:
                        break
                    }
                }
//                for document in snapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//
//                    if let comment = Comment.parse(document.data()) {
//                        self.comments.append(comment)
//                    }
//                }
                self.comments.insert(contentsOf: newComments, at: 0)
                let indexPaths = (0..<newComments.count).map { i in
                    return IndexPath(row: i, section: 1)
                }
                self.tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
//        let ref = db.collection("comments")
//
//        ref.addSnapshotListener { snapshot, error in
//
//        }
    }
    
    func stopObservingComments() {
        
    }
    
    
    func displayJoinIfNeeded() {
        if let userProfile = UserManager.shared.userProfile {
            joinButton.isHidden = true
            //commentBar.isHidden = false
        } else {
            joinButton.isHidden = false
            //commentBar.isHidden = true
        }
    }
    
    
    @objc func keyboardWillShow(notification:Notification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else { return }
        //tableViewBottomAnchor.constant = -keyboardSize.height
        commentBottomAnchor.constant = -(keyboardSize.height)
        commentBar.keyboardWillShow()
        view.layoutIfNeeded()
    }
        
    @objc func keyboardWillHide(notification:Notification) {
        
        commentBottomAnchor.constant = commentBar.bounds.height
        commentBar.keyboardWillHide()
        //view.layoutIfNeeded()
    }

    @objc func openCreateProfile() {
        let vc = CreateProfileViewController()
        vc.delegate = self
        vc.view.backgroundColor = UIColor.systemBackground
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
}

extension ChatOverlayViewController: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return comments.count
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        if indexPath.section == 0 {
            let node = AddCommentCellNode()
            return node
        }
        let node = CommentCellNode()
        node.setComment(comments[indexPath.row])
        return node
    }
    
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        tableNode.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            let _ = commentBar.becomeFirstResponder()
        } else {
            
        }
    }
    
}

extension ChatOverlayViewController: CreateProfileDelegate {
    func createProfileDidComplete() {
        self.displayJoinIfNeeded()
    }
}

extension ChatOverlayViewController: CommentBarDelegate {
    func commentBar(didSend comment: String) {
        /*comments.insert(comment, at: 0)
        
        self.tableView.reloadData()//insertRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
        let _ = self.commentBar.resignFirstResponder()*/
        
        //let ref = Database.database().reference(withPath: "app/room/\(stock.symbol)/messages")
        
        // Add a new document in collection "cities"
        
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let profile = UserManager.shared.userProfile else { return }
        let db = Firestore.firestore()
        commentBar.sendButton.isEnabled = false
        
        let comment = [
            "uid": uid,
            "profile": [
                "username": profile.username,
                "profile_image_url": profile.profileImageURL.absoluteString
            ],
            "text": comment,
            "roomID": stock.symbol,
            "dateCreated": Date().timeIntervalSince1970
        ] as [String:Any]
        
        db.collection("comments").addDocument(data: comment) { error in
            /// TODO: handle
        }
        
        /*
        db.collection("cities").document("LA").setData([
            "name": "Los Angeles",
            "state": "CA",
            "country": "USA"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }*/
        
        
    }
}
*/
