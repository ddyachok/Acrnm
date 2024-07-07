//
//  RootView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 27.06.2024.
//

import SwiftUI

struct RootView: View {
    @ObservedObject var coordinator: RootCoordinator
    
    var body: some View {
        if let currentView = coordinator.currentView {
            currentView
        }
        else {
            ProgressView()
        }
    }
}
