//
//  SceneDelegate.swift
//  MapkitSamples
//
//  Created by Daniil Pustotin on 05.07.2023.
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
        window?.rootViewController = UINavigationController(rootViewController: MapViewController())
        window?.makeKeyAndVisible()
    }
}
