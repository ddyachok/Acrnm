//
//  HomeView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 04.07.2024.
//

import SwiftUI
import Routing


// MARK: - Internal Types -

fileprivate enum Constants {
}

struct DetailsView<VM: DetailsViewModelType>: View {
    
    // MARK: - Properties (public) -
    
    @StateObject var viewModel: VM
    
    // MARK: - Properties (private) -
    
    @StateObject private var router: Router<HomeRoute> = .init()
    
    var body: some View {
        RoutingView(stack: $router.stack) {
            VStack {
                Text("Hello, World!")
                Button(action: {
                    router.navigate(to: .details)
                }, label: {
                    Text("Show details")
                })
                Button(action: {
                    router.navigateToRoot()
                }, label: {
                    Text("Go to home")
                })
            }
            .navigationTitle("Details \(Int.random(in: 1...100))")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(viewModel: DetailsViewModel())
    }
}
