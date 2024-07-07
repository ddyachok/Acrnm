//
//  GlitchEffect.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 06.07.2024.
//

import SwiftUI

struct GlitchEffect: ViewModifier {
    @State private var glitchOffset: CGFloat = 0.0
    
    func body(content: Content) -> some View {
        content
            .colorInvert()
            .offset(x: glitchOffset, y: glitchOffset)
            .animation(
                Animation.easeInOut(duration: 0.1)
                    .repeatForever(autoreverses: true)
            )
            .onAppear {
                glitchOffset = CGFloat.random(in: -10...10)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    glitchOffset = CGFloat.random(in: -10...10)
                }
            }
    }
}
