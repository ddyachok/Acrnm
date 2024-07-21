//
//  UnitCellView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 15.07.2024.
//

import SwiftUI

struct UnitCellView: View {
    
    var product: ProductModel
    
    var body: some View {
        HStack(spacing: 0) {
            HStack(alignment: .center, spacing: 0) {
                Text(L10n.productsCollectionUnit)
                    .foregroundStyle(.smokyBlack)
                    .font(FontFamily.BeVietnamPro.light.swiftUIFont(fixedSize: 7))
                    .rotationEffect(.degrees(-90))
                    .padding(.leading, 4)
                
                Spacer()
                
                Text(product.title)
                    .foregroundStyle(.smokyBlack)
                    .font(FontFamily.BeVietnamPro.bold.swiftUIFont(size: 14))
                    .padding(.trailing, 8)
            }
            
            Spacer()
            
            ZStack {
                Color(.smokyBlack)
                    .frame(width: 48, height: 48)
                Image(.arrowRightIcon)
                    .foregroundColor(Asset.Colors.Neutral.white.swiftUIColor)
                    .padding()
            }
        }
        .background(Asset.Colors.Neutral.white.swiftUIColor)
    }
}
