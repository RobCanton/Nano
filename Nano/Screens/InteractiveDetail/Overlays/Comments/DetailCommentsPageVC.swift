//
//  DetailCommentsPageVC.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-07-07.
//

import UIKit
import Firebase
import AsyncDisplayKit

class DetailCommentsPageVC:OverlayViewController {
    
    let item:MarketItem
    init(item:MarketItem) {
        self.item = item
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
    var comments = [Comment]()
    
    var joinButton:AlertBannerView!
    
    var commentsListener:ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Chat Room", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(handleDismiss))
        
        navigationController?.navigationBar.tintColor = UIColor.label
        
        commentBar = CommentBar()
        commentBar.delegate = self
        
        contentView.addSubview(commentBar)
        commentBar.constraintToSuperview(nil, 0, nil, 0, ignoreSafeArea: false)
        commentBottomAnchor = commentBar.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        commentBottomAnchor.isActive = true
        
        contentView.insertSubview(tableView, at: 0)
        tableView.constraintToSuperview(0, 0, nil, 0, ignoreSafeArea: false)
        tableView.bottomAnchor.constraint(equalTo: commentBar.topAnchor).isActive = true
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = UIView()
        tableView.separatorStyle = .none
        //tableView.keyboardDismissMode = .onDrag
        //tableView.separatorInset = .zero
        tableView.showsVerticalScrollIndicator = false
        
        tableNode.inverted = true
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.reloadData()
        
        joinButton = AlertBannerView()
        contentView.addSubview(joinButton)
        joinButton.constraintToSuperview(nil, 12, 12, 12, ignoreSafeArea: false)
        joinButton.constraintHeight(to: 52)
        joinButton.button.addTarget(self, action: #selector(openCreateProfile), for: .touchUpInside)
        joinButton.isHidden = true
        joinButton.title = "Join the conversation"
        
        displayJoinIfNeeded()
        
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
    
    @objc func openCreateProfile() {
        let vc = CreateProfileViewController(isPopup: true)
        vc.delegate = self
        vc.view.backgroundColor = UIColor.systemBackground
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        fetchComments {
            self.observeComments()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        stopObservingComments()
    }
    
    @objc func keyboardWillShow(notification:Notification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue  else { return }
        //tableViewBottomAnchor.constant = -keyboardSize.height
        commentBottomAnchor.constant = -(keyboardSize.height)
        commentBar.keyboardWillShow()
        view.layoutIfNeeded()
    }
        
    @objc func keyboardWillHide(notification:Notification) {
        
        commentBottomAnchor.constant = 0//commentBar.bounds.height
        commentBar.keyboardWillHide()
        view.layoutIfNeeded()
    }
    
    func fetchComments(completion: @escaping ()->()) {
        let db = Firestore.firestore()
        let ref = db.collection("comments").whereField("roomID", isEqualTo: item.symbol).order(by: "dateCreated", descending: true)
        ref.getDocuments() { querySnapshot, err in
            if let err = err {
                print("Error: \(err)")
            } else {
                var _comments = [Comment]()
                for document in querySnapshot!.documents {
                    if let comment = Comment.parse(document.data()) {
                        _comments.append(comment)
                    }
                }
                self.comments = _comments
                self.tableNode.reloadData()
                completion()
            }
        }
    }
    
    func observeComments() {
        stopObservingComments()
        let db = Firestore.firestore()
        let ref = db.collection("comments").whereField("roomID", isEqualTo: item.symbol)
        
        var query:Query
        if let latestComment = comments.first {
            let timestamp = latestComment.dateCreated.timeIntervalSince1970 * 1000
            query = ref.order(by: "dateCreated", descending: true).end(before: [timestamp])
        } else {
            query = ref.order(by: "dateCreated", descending: true)
        }
        
        commentsListener = query.addSnapshotListener{ snapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                
                var newComments = [Comment]()
                for document in snapshot!.documentChanges {
                    switch document.type {
                    case .added:
                        if let comment = Comment.parse(document.document.data()) {
                            newComments.append(comment)
                        }
                        break
                    default:
                        break
                    }
                }

                self.comments.insert(contentsOf: newComments, at: 0)
                let indexPaths = (0..<newComments.count).map { i in
                    return IndexPath(row: i, section: 1)
                }
                
                self.tableNode.insertRows(at: indexPaths, with: .top)
            }
        }

    }
        
    func stopObservingComments() {
        commentsListener?.remove()
    }
}

extension DetailCommentsPageVC: ASTableDelegate, ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        return comments.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
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

extension DetailCommentsPageVC: CreateProfileDelegate {
    func createProfileDidComplete() {
        self.displayJoinIfNeeded()
    }
}

extension DetailCommentsPageVC: CommentBarDelegate {
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
            "roomID": item.symbol,
            "dateCreated": Date().timeIntervalSince1970 * 1000
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
