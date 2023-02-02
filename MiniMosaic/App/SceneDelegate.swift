//
//  SceneDelegate.swift
//  MiniMosaic
//
//  Created by Anton Solovev on 12.01.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let environment = AppEnvironment.live
        let viewController = MiniAppListViewController(environment: environment)
        let navigationController = UINavigationController(rootViewController: viewController)

        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
