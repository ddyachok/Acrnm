//
//  SavedProductsView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 25.07.2024.
//

import SwiftUI
import NSideMenu
import Routing

// MARK: - Constants

private enum Constants {
    enum Sidebar {
        static let minimalDragWidth: CGFloat = 100
    }
}

// MARK: - ProductsListView

struct SavedProductsView<VM: SavedProductsViewModelType>: View {
    
    // MARK: - Properties (public)
    
    @StateObject var viewModel: VM
    
    // MARK: - Properties (private)
    
    @EnvironmentObject private var appRootManager: AppRootManager
    @StateObject private var router: Router<SavedProductsRoute> = .init()
    
    @StateObject private var sideMenuOptions = NSideMenuOptions(style: .slideAside)
    @State private var selectedSideMenuOption: SideBarOption = .savedItems
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            NSideMenuView(options: sideMenuOptions) {
                Menu {
                    SideBarView(selectedOption: $selectedSideMenuOption, alignment: .leading)
                }
                Main {
                    contentView
                }
            }
            .onAppear() {
                selectedSideMenuOption = .savedItems
            }
            .onChange(of: selectedSideMenuOption) { _, newOption in
                handleSideMenuSelection(newOption)
            }
            .onChange(of: router.stack) { _, newStack in
                if newStack.isEmpty {
                    selectedSideMenuOption = .savedItems
                }
            }
        }
    }
    
    // MARK: - Views (private)
    
    private var contentView: some View {
        ZStack {
            Color(Asset.Colors.Primary.wildBlueYonder.color)
                .ignoresSafeArea(.all)
            
            VStack(spacing: 0) {
                productsList
            }
            .padding(.top, UIApplication.shared.topSafeAreaHeight + 24)
            .navigationBarBackButtonHidden(true)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                sideBarButton
                
                ToolbarItem(placement: .topBarTrailing) {
                    Text(L10n.tabBarSavedItemsTitle)
                        .foregroundColor(Asset.Colors.Neutral.white.swiftUIColor)
                        .font(FontFamily.BeVietnamPro.light.swiftUIFont(size: 18))
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    private var sideBarButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: toggleSideMenu) {
                Image(systemName: "line.3.horizontal")
                    .foregroundStyle(.white)
            }
        }
    }
        
    private var productsList: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(viewModel.products) { product in
                    SavedProductCell(product: product)
                        .onTapGesture {
                            router.navigate(to: .details(product: product))
                        }
                }
                .padding([.leading, .trailing], 28)
            }
            .padding(.bottom, 24)
        }
        .onAppear {
            Task {
                viewModel.getSavedProducts()
            }
        }
    }
    
    // MARK: - Methods (private)
    
    private func handleSideMenuSelection(_ option: SideBarOption) {
        switch option {
        case .home:
            if sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
            
            appRootManager.currentRoot = .home
            
        case .items:
            if sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
            
            appRootManager.currentRoot = .products
            
        case .savedItems:
            if sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
        }
    }
    
    private func toggleSideMenu() {
        DispatchQueue.main.async {
            sideMenuOptions.toggleMenu()
        }
    }
    
    private func handleGesture(_ value: DragGesture.Value) {
        if value.translation.width > Constants.Sidebar.minimalDragWidth {
            if !sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
        }
        else if value.translation.width < -Constants.Sidebar.minimalDragWidth {
            if sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
        }
    }
}

struct SavedProductsView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SavedProductsViewModel()
        SavedProductsView(viewModel: viewModel)
    }
}
