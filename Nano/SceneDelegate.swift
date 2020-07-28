//
//  SceneDelegate.swift
//  Nano
//
//  Created by Robert Canton on 2020-07-26.
//  Copyright © 2020 Robert Canton. All rights reserved.
//


import UIKit
import Firebase
import UserNotifications
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var authListener:AuthStateDidChangeListenerHandle?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        self.openLoadingScreen()
        fetchRequirements {
            self.listenToAuth()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }

    func fetchRequirements(completion: @escaping()->()) {
        return completion()
    }

    func listenToAuth() {
        if let listener = authListener {
            Auth.auth().removeStateDidChangeListener(listener)
        }
        
        authListener = Auth.auth().addStateDidChangeListener { (auth, user) in
            print("Auth state did change user:\(user != nil)")
            if let user = user {
                print("RXC: user logged in, move to home screen")
                user.getIDTokenForcingRefresh(true, completion: { token, error in
                    if let token = token, error == nil {
                        RavenAPI.authToken = token
                        
                        self.openLoadingScreen()
                        self.fetchUserData {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                self.openHomeScreen()
                            })
                        }
                    } else {
                        do {
                            try Auth.auth().signOut()
                        } catch {}
                        self.openLoginScreen()
                    }
                })
            } else {
                
                guard let rootVC = self.window?.rootViewController else { return }
                
                if rootVC.children.count == 0 {
                    self.openLoginScreen()
                } else {
                    self.window?.rootViewController?.dismiss(animated: false, completion: {
                        self.openLoginScreen()
                    })
                }
                
            }
        }
        
    }
    
    func openLoginScreen() {
        let controller = SignInViewController()
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
    }
    
    func openLoadingScreen() {
        let controller = LoadingViewController()
        self.window?.rootViewController = controller
        self.window?.makeKeyAndVisible()
    }
    
    func openHomeScreen() {
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        
        UIApplication.shared.registerForRemoteNotifications()
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                //UserService.fcmToken = result.token
            }
        }
        
        guard let loadingVC = self.window?.rootViewController as? LoadingViewController else { return }
        loadingVC.fadeout {
            let controller = RootTabBarController()
            self.window?.rootViewController = controller
            self.window?.makeKeyAndVisible()
        }
        
        
    }
    
    func fetchUserData(completion: @escaping (()->())) {
        
        RavenAPI.registerPushToken()
        
        //StoreManager.shared.fetchProducts()
        
        NotificationManager.shared.start()
        UserManager.shared.configure {
            
            RavenAPI.getInitialSnapshot { response in
                print("Initial!")
            
                let stocks:[String:MarketItem] = response.snapshots?.stocks ?? [:]
                let forex:[String:MarketItem] = response.snapshots?.forex ?? [:]
                let crypto:[String:MarketItem] = response.snapshots?.crypto ?? [:]
                
                let stocksAndForex = stocks.merging(forex) { (current, _) in current }
                let stocksForexAndCrypto = stocksAndForex.merging(crypto) { (current, _) in current }
                
                MarketManager.shared.configure(marketStatus: response.marketStatus,
                                              items: stocksForexAndCrypto,
                                              lists: Lists(response.lists))
                
                AlertManager.shared.configure(alerts: response.alerts)
                
                NewsManager.shared.configure(topics: response.news.topics)
                
                completion()
            }
            
        }
        
    }

}

