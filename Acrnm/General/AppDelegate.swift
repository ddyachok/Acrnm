//
//  AppDelegate.swift
//  Template
//
//  Created by NerdzLab
//

import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureAppStart(with: launchOptions)
    }
}

private extension AppDelegate {
    func configureAppStart(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureRootCoordinator(with: launchOptions)
        return true
    }

    func configureRootCoordinator(with launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootCoordinator = RootCoordinator(launchOptions: launchOptions)
        let rootView = RootView(coordinator: rootCoordinator) // RootView is a SwiftUI view that observes RootCoordinator
        window.rootViewController = UIHostingController(rootView: rootView)
        window.makeKeyAndVisible()
        self.window = window
    }
}
