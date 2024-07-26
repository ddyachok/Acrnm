//
//  ProductsListView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 07.07.2024.
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

struct ProductsListView<VM: ProductsListViewModelType>: View {
    
    // MARK: - Properties (public)
    
    @StateObject var viewModel: VM
    @ObservedObject var router: Router<HomeRoute>
    
    // MARK: - Properties (private)
    
    @EnvironmentObject private var appRootManager: AppRootManager
    
    @StateObject private var sideMenuOptions = NSideMenuOptions(style: .slideAside, side: .trailing)
    @State private var selectedSideMenuOption: SideBarOption = .items
    
    // MARK: - Body
    
    var body: some View {
        RoutingView(stack: $router.stack) {
            NSideMenuView(options: sideMenuOptions) {
                Menu {
                    SideBarView(selectedOption: $selectedSideMenuOption, alignment: .trailing)
                }
                Main {
                    contentView
                }
            }
            .onChange(of: selectedSideMenuOption) { _, newOption in
                handleSideMenuSelection(newOption)
            }
        }
    }
    
    // MARK: - Views (private)
    
    private var contentView: some View {
        GestureAwareView(onGesture: handleGesture) {
            ZStack {
                Color(Asset.Colors.Primary.wildBlueYonder.color)
                
                VStack(spacing: 0) {
                    productList
                }
                .padding(.top, UIApplication.shared.topSafeAreaHeight + 24)
                .onTapGesture {
                    if sideMenuOptions.show {
                        sideMenuOptions.toggleMenu()
                    }
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(
                    leading: router.stack.isEmpty ? nil : backButton,
                    trailing: sideMenuButton
                )
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Text("ACRONYM®")
                            .foregroundColor(Asset.Colors.Neutral.white.swiftUIColor)
                            .font(FontFamily.BeVietnamPro.bold.swiftUIFont(size: 18))
                    }
                }
                .toolbarBackground(.visible, for: .navigationBar)
            }
        }
    }
    
    private var backButton: some View {
        Button(action: {
            router.navigateBack()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(Asset.Colors.Neutral.white.swiftUIColor)
        }
    }
    
    private var sideMenuButton: some View {
        Button(action: {
            sideMenuOptions.toggleMenu()
        }) {
            Image(systemName: "line.3.horizontal")
                .foregroundColor(Asset.Colors.Neutral.white.swiftUIColor)
        }
    }
    
    private var productList: some View {
        ScrollView {
            VStack(spacing: 28) {
                if let firstProduct = viewModel.products.first {
                    MainProductCell(product: firstProduct)
                        .padding(.top, 24)
                        .padding([.leading, .trailing], 28)
                        .onTapGesture {
                            router.navigate(to: .details(product: firstProduct, router: router))
                        }
                }
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 28) {
                    ForEach(viewModel.products.dropFirst()) { product in
                        SecondaryProductCell(product: product)
                            .onTapGesture {
                                router.navigate(to: .details(product: product, router: router))
                            }
                    }
                }
                .padding([.leading, .trailing], 28)
            }
            .padding(.bottom, 24)
        }
        .onAppear {
            viewModel.getProducts()
        }
    }
    
    // MARK: - Methods (private)
    
    private func handleSideMenuSelection(_ newOption: SideBarOption) {
        switch newOption {
        case .home:
            if sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
            
            if router.stack.isEmpty {
                appRootManager.currentRoot = .home
            }
            else {
                router.navigateToRoot()
            }
            
        case .items:
            if sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
            
        case .savedItems:
            if sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
            
            appRootManager.currentRoot = .savedProducts
        }
    }
    
    private func handleGesture(_ value: DragGesture.Value) {
        let threshold = Constants.Sidebar.minimalDragWidth
        if value.translation.width < -threshold {
            if !sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
        }
        else if value.translation.width > threshold {
            if sideMenuOptions.show {
                sideMenuOptions.toggleMenu()
            }
        }
    }
}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ProductsListViewModel()
        ProductsListView(viewModel: viewModel, router: Router<HomeRoute>.init())
    }
}
