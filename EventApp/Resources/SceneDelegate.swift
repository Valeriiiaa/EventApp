//
//  SceneDelegate.swift
//  EventApp
//
//  Created by Valeriya Chernyak on 23.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        DispatchQueue.main.async { [unowned self] in
            guard let windowScene = (scene as? UIWindowScene) else { return }
            window = UIWindow(windowScene: windowScene)
            var splashStoryboard = StoryboardFabric.getStoryboard(by: "Main").instantiateViewController(withIdentifier: "MainViewController")
            if let token: String = UserDefaultsStorage.shared.get(key: .token) {
                registerDependency(token: token)
                splashStoryboard = StoryboardFabric.getStoryboard(by: "Main").instantiateViewController(withIdentifier: "MessagesViewController")
            }
            let navigationController = UINavigationController(rootViewController: splashStoryboard)
            navigationController.isNavigationBarHidden = true
            navigationController.navigationBar.tintColor = UIColor(named: "TintColor")
            window?.rootViewController = navigationController
            window?.makeKeyAndVisible()
            DrawerMenuViewController.shared.drawerNavigationController = navigationController
            guard let response = connectionOptions.notificationResponse else { return }
            let userInfo = response.notification.request.content.userInfo
            print(userInfo)
            let notificationIdString = userInfo["gcm.notification.id"] as? String ?? ""
            let notificationId = Int(notificationIdString) ?? 0
            guard userInfo["gcm.notification.type"] as? String == "Ticket" else { return }
            DrawerMenuViewController.shared.openChatAskAQuestion(chatId: notificationId)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
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
    
    private func registerDependency(token: String) {
        let container = AppDelegate.contaienr
        container.register(UserManager.self, factory: { r in
            print("registered")
            return UserManager(token: token)
        }).inObjectScope(.container)
    }
    
}

