//
//  HomeView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 04.07.2024.
//

import SwiftUI
import Routing
import NSideMenu

// MARK: - Internal Types -

fileprivate enum Constants {
    enum Sidebar {
        static let minimalDragWidth: CGFloat = 100
    }
}

struct HomeView<VM: HomeViewModelType>: View {
    
    // MARK: - Properties (public) -
    
    @StateObject var viewModel: VM
    
    // MARK: - Properties (private) -
    
    @StateObject private var router: Router<HomeRoute> = .init()
    @StateObject private var sideMenuOptions = NSideMenuOptions(style: .slideAside)
        
    // MARK: - Body -
    
    var body: some View {
        NSideMenuView(options: sideMenuOptions){
            Menu {
                SideBarView()
            }
            Main {
                mainView
                    .onTapGesture {
                        if sideMenuOptions.show == true {
                            sideMenuOptions.toggleMenu()
                        }
                    }
            }
        }
    }
    
    // MARK: - Views (private) -
    
    private var mainView: some View {
        RoutingView(stack: $router.stack) {
            ZStack {
                backgroundImage
                overlayContent
            }
            .navigationTitle(L10n.appTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                sideBarButton
                topBarSearchButton
                topBarCartButton
            }
        }
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
            Spacer()
                .frame(height: 48)
            Button(action: {
                router.navigate(to: .details)
            }) {
                Text(L10n.homeViewCollection)
                    .font(FontFamily.BeVietnamPro.medium.swiftUIFont(size: 18))
                    .foregroundColor(Color(uiColor: Asset.Colors.Neutral.white.color))
                    .padding()
                    .background(Color(uiColor: Asset.Colors.Neutral.smokyBlack.color))
            }
            Spacer()
                .frame(height: 40)
        }
        .padding()
    }
    
    private var sideBarButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: {
                DispatchQueue.main.async {
                    sideMenuOptions.toggleMenu()
                }
            }) {
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.white)
            }
        }
    }
    
    private var topBarSearchButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                // Add search action
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
            }
        }
    }
    
    private var topBarCartButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                // Add cart action
            }) {
                Image(systemName: "cart")
                    .foregroundColor(.white)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(viewModel: HomeViewModel())
    }
}
