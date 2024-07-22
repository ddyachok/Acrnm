//
//  GestureAwareView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 22.07.2024.
//

import SwiftUI

struct GestureAwareView<Content: View>: View {
    let content: Content
    let onGesture: (DragGesture.Value) -> Void

    init(onGesture: @escaping (DragGesture.Value) -> Void, @ViewBuilder content: () -> Content) {
        self.onGesture = onGesture
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            content
                .contentShape(Rectangle())
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { value in
                            let frame = geometry.frame(in: .global)
                            
                            if frame.contains(value.location) {
                                onGesture(value)
                            }
                        }
                )
        }
    }
}
