//
//  SceneDelegate.swift
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    // MARK: - Public properties

    var window: UIWindow?

    // MARK: - Public methods

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }

        self.window = UIWindow(windowScene: windowScene)

        let navigationController = UINavigationController(rootViewController: MapViewController())

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
