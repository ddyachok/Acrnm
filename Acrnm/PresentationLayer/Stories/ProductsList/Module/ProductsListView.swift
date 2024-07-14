//
//  ProductsListView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 07.07.2024.
//

import SwiftUI
import NSideMenu
import Routing

// MARK: - Internal Types -

fileprivate enum Constants {
    enum Sidebar {
        static let minimalDragWidth: CGFloat = 100
    }
}

struct ProductsListView<VM: ProductsListViewModelType>: View {
    
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
                VStack {
                    // Category Picker
                    Picker(selection: $viewModel.selectedCategory, label: Text("Category")) {
                        //                    ForEach(viewModel.categories) { category in
                        //                      Text(category.title)
                        //                    }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    
                    // Product list
                    List {
//                        ForEach(viewModel.products) { product in
//                            MainProductCell(product: product)
//                        }
                    }
                    .onAppear {
                        viewModel.getProducts() // Fetch products on view appear
                    }
                }
                .onTapGesture {
                    if sideMenuOptions.show == true {
                        sideMenuOptions.toggleMenu()
                    }
                }
            }
        }
    }
    
}
