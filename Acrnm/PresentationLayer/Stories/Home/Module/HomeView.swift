//
//  HomeView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 04.07.2024.
//

import SwiftUI
import Routing
import NSideMenu

// MARK: - Constants

private enum Constants {
    static let swipeThreshold: CGFloat = 100
}

// MARK: - HomeView

struct HomeView<VM: HomeViewModelType>: View {
    
    // MARK: - Properties (public)
    
    @StateObject var viewModel: VM
    
    // MARK: - Properties (private)
    
    @EnvironmentObject private var appRootManager: AppRootManager
    @StateObject private var router: Router<HomeRoute> = .init()
    
    @StateObject private var sideMenuOptions = NSideMenuOptions(style: .slideAside)
    @State private var selectedSideMenuOption: SideBarOption = .home
    
    // MARK: - Body
    
    var body: some View {
        NSideMenuView(options: sideMenuOptions) {
            Menu {
                SideBarView(selectedOption: $selectedSideMenuOption, alignment: .leading)
            }
            Main {
                contentView
            }
        }
        .onChange(of: selectedSideMenuOption) { _, newOption in
            handleSideMenuSelection(newOption)
        }
        .onChange(of: router.stack) { _, newStack in
            if newStack.isEmpty {
                selectedSideMenuOption = .home
            }
        }
    }
    
    // MARK: - Private Views
    
    private var contentView: some View {
        GestureAwareView(onGesture: handleGesture) {
            mainView
                .onTapGesture {
                    if sideMenuOptions.show {
                        sideMenuOptions.toggleMenu()
                    }
                }
        }
    }
    
    private var mainView: some View {
        RoutingView(stack: $router.stack) {
            ZStack {
                backgroundImage
                overlayContent
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                sideBarButton
            }
        }
        .environmentObject(router)
    }
    
    private var backgroundImage: some View {
        Image(uiImage: Asset.Images.j118WsEx1.image)
            .resizable()
            .scaledToFill()
            .edgesIgnoringSafeArea(.all)
            .padding(.trailing, 100)
    }
    
    private var overlayContent: some View {
        VStack {
            Spacer()
            Text(L10n.acronymCopyright)
                .font(FontFamily.BeVietnamPro.bold.swiftUIFont(size: 14))
                .foregroundColor(Color(uiColor: Asset.Colors.Neutral.white.color))
                .padding(.bottom, 4)
            Text(L10n.collectionS24)
                .font(FontFamily.BeVietnamPro.semiBold.swiftUIFont(size: 32))
                .fontWeight(.bold)
                .foregroundColor(Color(uiColor: Asset.Colors.Neutral.white.color))
            Spacer().frame(height: 48)
            Button(action: { router.navigate(to: .productsList(router: router)) }) {
                Text(L10n.homeViewCollection)
                    .font(FontFamily.BeVietnamPro.medium.swiftUIFont(size: 18))
                    .foregroundColor(Color(uiColor: Asset.Colors.Neutral.white.color))
                    .padding()
                    .background(Color(uiColor: Asset.Colors.Neutral.smokyBlack.color))
            }
            Spacer().frame(height: 40)
        }
        .padding()
    }
    
    private var sideBarButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: toggleSideMenu) {
                Image(systemName: "line.3.horizontal")
                    .foregroundStyle(.smokyBlack)
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
            
        case .items:
            if sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
            
            appRootManager.currentRoot = .products
            
        case .savedItems:
            if sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
            
            appRootManager.currentRoot = .savedProducts
        }
    }
    
    private func toggleSideMenu() {
        DispatchQueue.main.async {
            sideMenuOptions.toggleMenu()
        }
    }
    
    private func handleGesture(_ value: DragGesture.Value) {
        if value.translation.width > Constants.swipeThreshold {
            if !sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
        }
        else if value.translation.width < -Constants.swipeThreshold {
            if sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
