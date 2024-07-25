//
//  HomeRoute.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 06.07.2024.
//

import Routing
import SwiftUI

enum HomeRoute: Routable, Equatable {
    case details(product: ProductModel, router: Router<HomeRoute>)
    case productsList(router: Router<HomeRoute>)
    
    var body: some View {
        switch self {
        case .details(let product, let router):
            ProductDetailsView(viewModel: ProductDetailsViewModel(product: product), router: router)
            
        case .productsList(let router):
            ProductsListView(viewModel: ProductsListViewModel(selectedCategory: .ss24), router: router)
        }
    }
    
    // Implement Hashable conformance
    func hash(into hasher: inout Hasher) {
        switch self {
        case .details(let product, _):
            hasher.combine(product.id)
            
        case .productsList:
            hasher.combine("productsList")
        }
    }
    
    // Implement Equatable conformance
    static func == (lhs: HomeRoute, rhs: HomeRoute) -> Bool {
        switch (lhs, rhs) {
        case (.details(let lhsProduct, _), .details(let rhsProduct, _)):
            return lhsProduct.id == rhsProduct.id
        case (.productsList, .productsList):
            return true
            
        case (.productsList, .details(product: let product, _)):
            return false
            
        case (.details(product: let product, _), .productsList):
            return false
        }
    }
}
