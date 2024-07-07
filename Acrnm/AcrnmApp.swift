//
//  AcrnmApp.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 27.06.2024.
//

import SwiftUI

@main
struct AcrnmApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            RootView(coordinator: RootCoordinator(launchOptions: nil))
        }
    }
}
