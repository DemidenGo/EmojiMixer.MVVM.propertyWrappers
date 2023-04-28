//
//  SceneDelegate.swift
//  EmojiMixer
//
//  Created by Юрий Демиденко on 03.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let viewController = ViewController()
        let emojiMixFactory = EmojiMixFactory()
        let emojiMixStore = EmojiMixStore()
        let viewModel = EmojiMixesViewModel(emojiMixFactory: emojiMixFactory, emojiMixStore: emojiMixStore)
        viewController.initialize(viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }
}
