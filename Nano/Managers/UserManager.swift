//
//  UserManager.swift
//  Stockraven-iOS
//
//  Created by Robert Canton on 2020-06-04.
//

import Foundation
import Firebase

class UserManager {
    static let shared = UserManager()
    
    var userProfile:UserProfile?
    var isPremiumAccount = false
    
    private init() {
        
    }
    
    func configure(completion: @escaping ()->()) {
        fetchAccount {
            self.fetchUserProfile {
                completion()
            }
        }
    }
    
//    func fetchUserProfile(completion: @escaping ()->()) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        
//        let ref = Database.database().reference(withPath: "app/user/profile/\(uid)")
//        ref.observeSingleEvent(of: .value, with: { snapshot in
//            if let data = snapshot.value as? [String:Any],
//                let username = data["username"] as? String,
//                let profileImageURLStr = data["profile_image_url"] as? String,
//                let profileImageURL = URL(string: profileImageURLStr) {
//                
//                self.userProfile = UserProfile(username: username,
//                                               profileImageURL: profileImageURL)
//            } else {
//                self.userProfile = nil
//            }
//            completion()
//        })
//    }
    
    func fetchAccount(completion: @escaping ()->()) {
        RavenAPI.userAccount { response in
            print("Response: \(response)")
            guard let response = response else {
                try! Auth.auth().signOut()
                return
            }
            completion()
        }
    }
    
    func fetchUserProfile(completion: @escaping ()->()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let firestore = Firestore.firestore()
        let ref = firestore.collection("userProfiles").document(uid)
        ref.getDocument { snapshot, error in
            if let data = snapshot?.data(),
                let username = data["username"] as? String,
                let profileImageURLStr = data["profileImageURL"] as? String,
                let profileImageURL = URL(string: profileImageURLStr) {
                
                self.userProfile = UserProfile(username: username, profileImageURL: profileImageURL)
            }
            
            completion()
        }
    }
}
