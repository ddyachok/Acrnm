//
//  SideBarView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 07.07.2024.
//

import SwiftUI

struct SideBarView: View {
    var onHomeButtonTapped: EmptyAction?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Profile")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 100)
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Messages")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
                .padding(.top, 30)
            HStack {
                Image(systemName: "gear")
                    .foregroundColor(.gray)
                    .imageScale(.large)
                Text("Settings")
                    .foregroundColor(.gray)
                    .font(.headline)
            }
            .padding(.top, 30)
            Spacer()
        }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(uiColor: Asset.Colors.Neutral.smokyBlack.color))
            .edgesIgnoringSafeArea(.all)
    }
}

struct SideBarView_Previews: PreviewProvider {
    static var previews: some View {
        SideBarView()
    }
}
