//
//  ProductsListView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 07.07.2024.
//

import SwiftUI
import NSideMenu
import Routing

fileprivate enum Constants {
    enum Sidebar {
        static let minimalDragWidth: CGFloat = 100
    }
}

struct ProductsListView<VM: ProductsListViewModelType>: View {
    
    // MARK: - Properties (public) -
    
    @StateObject var viewModel: VM
    
    // MARK: - Properties (private) -
    
    @EnvironmentObject private var router: Router<HomeRoute>
    @StateObject private var sideMenuOptions = NSideMenuOptions(style: .slideAside, side: .trailing)
    
    // MARK: - Body -
    
    var body: some View {
        NSideMenuView(options: sideMenuOptions) {
            Menu {
                SideBarView()
            }
            Main {
                ZStack {
                    Color(Asset.Colors.Primary.wildBlueYonder.color)
                    
                    VStack(spacing: 0) {
//                        categoryPicker
                        productList
                    }
                    .padding(.top, UIApplication.shared.topSafeAreaHeight + 24)
                    .onTapGesture {
                        if sideMenuOptions.show {
                            sideMenuOptions.toggleMenu()
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(leading: Button(action: {
                        router.navigateBack()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Asset.Colors.Neutral.white.swiftUIColor)
                    }, trailing: Button(action: {
                        // Handle sidebar toggle
                        sideMenuOptions.toggleMenu()
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(Asset.Colors.Neutral.white.swiftUIColor)
                    })
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
    }
    
    // MARK: - Category Picker -
    
//    private var categoryPicker: some View {
//        Picker(selection: $viewModel.selectedCategory, label: Text("Category")) {
//            ForEach(viewModel.categories, id: \.self) { category in
//                Text(category.title).tag(category as ProductCategoryType?)
//            }
//        }
//        .pickerStyle(.segmented)
//        .padding(.horizontal)
//    }
    
    // MARK: - Product List -
    
    private var productList: some View {
        ScrollView {
            VStack(spacing: 28) {
                // Display the main product cell for the first product
                if let firstProduct = viewModel.products.first {
                    MainProductCell(product: firstProduct)
                        .padding(.top, 24)
                        .padding([.leading, .trailing], 28)
                        .onTapGesture {
                            router.navigate(to: .details)
                        }
                }
                
                // Display secondary product cells for the remaining products
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 28) {
                    ForEach(viewModel.products.dropFirst()) { product in
                        SecondaryProductCell(product: product)
                            .onTapGesture {
                                router.navigate(to: .details)
                            }
                    }
                }
                .padding([.leading, .trailing], 28)
            }
            .padding(.bottom, 24)
        }
        .onAppear {
            viewModel.getProducts() // Fetch products on view appear
        }
    }
}

struct ProductsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ProductsListViewModel()
        ProductsListView(viewModel: viewModel)
    }
}
