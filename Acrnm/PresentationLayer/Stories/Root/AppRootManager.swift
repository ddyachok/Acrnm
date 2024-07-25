//
//  AppRootManager.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 25.07.2024.
//

import Foundation

final class AppRootManager: ObservableObject {
    
    @Published var currentRoot: SideBarRoots = .home
    
    enum SideBarRoots {
        case home
        case products
        case savedProducts
    }
}
