//
//  HomeRoute.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 06.07.2024.
//

import Routing
import SwiftUI

enum HomeRoute: Routable {
    case details
    case productsList
    
    var body: some View {
        switch self {
        case .details:
            DetailsView(viewModel: DetailsViewModel())
            
        case .productsList:
            ProductsListView(viewModel: ProductsListViewModel())
        }
    }
}
