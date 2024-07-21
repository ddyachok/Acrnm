//
//  UIApplication+SafeArea.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 21.07.2024.
//

import SwiftUI

extension UIApplication {
    var topSafeAreaHeight: CGFloat {
        guard let window = connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else {
            return 0
        }
        
        return window.safeAreaInsets.top
    }
}
