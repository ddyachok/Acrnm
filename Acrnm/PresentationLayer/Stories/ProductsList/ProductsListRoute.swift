//
//  ProductsListRoute.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 06.07.2024.
//

import Routing
import SwiftUI

enum ProductsListRoute: Routable, Equatable {
    case details(product: ProductModel)
    
    var body: some View {
        switch self {
        case .details(let product):
            ProductDetailsView(viewModel: ProductDetailsViewModel(product: product), router: Router<HomeRoute>.init())
        }
    }
    
    // Implement Hashable conformance
    func hash(into hasher: inout Hasher) {
        switch self {
        case .details(let product):
            hasher.combine(product.id)
        }
    }
    
    // Implement Equatable conformance
    static func == (lhs: ProductsListRoute, rhs: ProductsListRoute) -> Bool {
        switch (lhs, rhs) {
        case (.details(let lhsProduct), .details(let rhsProduct)):
            return lhsProduct.id == rhsProduct.id
        }
    }
}
