//
//  SideBarView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 07.07.2024.
//

import SwiftUI

enum SideBarOption: String, Identifiable {
    case home
    case items
    case savedItems
    
    var id: String {
        self.rawValue
    }
}

struct SideBarView: View {
    @Binding var selectedOption: SideBarOption
    
    let alignment: Alignment
    
    var body: some View {
        VStack(alignment: alignment.horizontal) {
            sidebarButton(for: .home, icon: Image(.homeIcon), text: L10n.tabBarHomeTitle)
                .padding(.top, 100)
            
            sidebarButton(for: .items, icon: Image(.viewGridIcon), text: L10n.tabBarItemsTitle)
                .padding(.top, 30)
            
            sidebarButton(for: .savedItems, icon: Image(.tagsIcon), text: L10n.tabBarSavedItemsTitle)
                .padding(.top, 30)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: alignment)
        .background(Color(uiColor: Asset.Colors.Neutral.smokyBlack.color))
        .edgesIgnoringSafeArea(.all)
    }
    
    private func sidebarButton(for option: SideBarOption, icon: Image, text: String) -> some View {
        Button(action: {
            selectedOption = option
        }) {
            HStack {
                if alignment == .leading {
                    leadingIconAndText(icon, text, option)
                }
                else if alignment == .trailing {
                    trailingIconAndText(icon, text, option)
                }
                else {
                    leadingIconAndText(icon, text, option)
                }
            }
        }
    }
    
    private func leadingIconAndText(_ icon: Image, _ text: String, _ option: SideBarOption) -> some View {
        HStack {
            icon
                .foregroundColor(foregroundColor(for: option))
            Text(text)
                .foregroundColor(foregroundColor(for: option))
                .font(FontFamily.BeVietnamPro.light.swiftUIFont(size: 18))
        }
    }
    
    private func trailingIconAndText(_ icon: Image, _ text: String, _ option: SideBarOption) -> some View {
        HStack {
            Text(text)
                .foregroundColor(foregroundColor(for: option))
                .font(FontFamily.BeVietnamPro.light.swiftUIFont(size: 18))
            icon
                .foregroundColor(foregroundColor(for: option))
        }
    }
    
    private func foregroundColor(for option: SideBarOption) -> Color {
        selectedOption == option ?
        Asset.Colors.Neutral.white.swiftUIColor :
        Asset.Colors.Neutral.wdGray.swiftUIColor
    }
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView(selectedOption: .constant(.home), alignment: .leading)
    }
}
