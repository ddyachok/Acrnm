//
//  AcrnmApp.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 27.06.2024.
//

import SwiftUI
import Routing

@main
struct AcrnmApp: App {
    @StateObject private var appRootManager = AppRootManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch appRootManager.currentRoot {
                case .home:
                    HomeView(viewModel: HomeViewModel())
                    
                case .products:
                    ProductsListView(viewModel: ProductsListViewModel(), router: Router<HomeRoute>.init())
                    
                case .savedProducts:
                    SavedProductsView(viewModel: SavedProductsViewModel())
                }
            }
            .environmentObject(appRootManager)
        }
    }
}


