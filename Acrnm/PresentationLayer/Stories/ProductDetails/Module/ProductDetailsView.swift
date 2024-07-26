//
//  ProductDetailsView.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 04.07.2024.
//

import SwiftUI
import Routing
import URLImage

// MARK: - ProductDetailsView

struct ProductDetailsView<VM: ProductDetailsViewModelType>: View {

    // MARK: - Properties (public) -
    
    @StateObject var viewModel: VM
    @ObservedObject var router: Router<HomeRoute>
        
    // MARK: - Body -
    
    var body: some View {
        ZStack {
            Color.smokyBlack.edgesIgnoringSafeArea(.all)
            
            ScrollView {
                productImages
                productDetails
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            viewModel.fetchLatestProductData()
        }
    }
    
    // MARK: - Views (private) -
        
    private var productImages: some View {
        TabView() {
            ForEach(viewModel.product.images.compactMap { $0 }, id: \.self) { url in
                URLImage(url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaledToFill()
                }
                .tag(url)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(height: 480)
        .padding([.leading, .trailing], 32)
        .padding(.bottom)
    }
    
    private var productDetails: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(viewModel.product.title)
                    .font(FontFamily.BeVietnamPro.medium.swiftUIFont(size: 20))
                    .foregroundColor(Asset.Colors.Neutral.white.swiftUIColor)
                
                Spacer()
                
                ZStack {
                    Color.white
                        .frame(width: 50, height: 50)
                    
                    Button(action: {
                        if viewModel.isProductSaved {
                            viewModel.removeProduct()
                        }
                        else {
                            viewModel.saveProduct()
                        }
                    }) {
                        Image(systemName: viewModel.isProductSaved ? "plus.viewfinder" : "plus")
                            .resizable()
                            .foregroundStyle(.smokyBlack)
                            .contentTransition(.symbolEffect(.replace.byLayer.downUp))
                            .frame(width: 25, height: 25)
                    }
                }
            }
            
            Text(viewModel.product.productDescription)
                .font(FontFamily.BeVietnamPro.regular.swiftUIFont(size: 12))
                .foregroundColor(Asset.Colors.Neutral.acrGray.swiftUIColor)
            
            Spacer()
        }
        .padding([.leading, .trailing], 32)
        .padding([.top, .bottom], 18)
        .background(.smokyBlack)
    }
    
    private var backButton: some View {
        Button(action: {
            router.navigateBack()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
        }
    }
}

// MARK: - Preview

struct ProductDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailsView(viewModel: ProductDetailsViewModel(product: j118_ws_ex), router: Router<HomeRoute>.init())
    }
}

// MARK: - Mock data -

fileprivate let j118_ws_ex = ProductModel(
    title: "J118-WS-EX",
    productDescription: """
Speed freak. J118-WS weighs in at an almost imperceptible 170g (not including removable parts). Enabler of this feat is the exceptional GORE WINDSTOPPER® membrane by Gore-Tex Labs: windproof, water repellent, highly breathable, compressible, and ultralight to degrees previously impossible. J118 packs into its own stow pocket which can be slotted to TEC SYS webbing, docked via carabiner, or slung via Jacketslingæ. Sleeve anchor cuffs and the storm hood keep you protected at speed. Jacketslingǽ with spike tape and Storm Hood with full coverage facemask push J118’s lightness and immateriality into the visceral.

[ Shown in size: M. Fits: PROFILE ]
""",
    images: [
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK1BWQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--069f359cbacb13df8deb1509a23bbc90ed3610da/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_165.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK1RWQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--9590519dc280e75a04bb0badc0967ab392b60350/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_174.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK1hWQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--477aa1257ab676abb438b6165e13f355cca159c6/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_186.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK2JWQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--6e3b6dfaeaf68164f80aad9acd59c03545e38f32/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_199.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK2ZWQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--39f4f79be4a68ff71f24f0acbdf83bcea3c4c5f2/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_209.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK2pWQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--cb88f145fefd284e68029144fd195565cd4fd955/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_226.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNVhxQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--a9c4c7398e26efa5d1b6f91ce00f0ac656f24364/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_257%201.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK3JWQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--1865332e880414d09d37e764500a9ddb483c5358/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_257.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK3ZWQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--3d2f209c2967078497fa9e30d9ca83415a26335d/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_279.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK3pWQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--a7fbb904809fa37cb9c9c33388dbb996a6fcf06a/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_282.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBKzNWQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--f768d1a916be2251002988e845a69e58dda1003b/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_288.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBKzdWQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--6e8b92a82ac03df086ee0bcf9b7b72b1a67f9737/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_296.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBd1hXQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--728bdc97e53c4bec6b27372065b6b49192992180/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_317.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBd2JXQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--11ef41a29e9fdce4df68befa6877702b7d48d58f/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_332.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBd2pXQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--a0168a15027ab623c12cd446fd3a9506846935ca/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_344.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBd25XQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--dd27b4bc3a7d89dcde36aa1079e31a32543f32bc/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_360.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBd3ZXQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--ed84dfc91f0ac2b6826da90efbb28b0a105aae47/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_382.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBd3pXQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--1a9002e0627d4c70190151d920474691b82bb9b5/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_390.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBdzNXQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--740a6f1f95e76b09bf5ab7f19d45bd29289c1cc8/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_407.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBdy9XQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--097fff6ffedcbdedf96e953ed5fefc224a7b1fba/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_417.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeERXQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--eb5c23ac8e2ba2b401fa959b6cc332d05853bd8e/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_431.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeEhXQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--fd7fe9f1e86fca1fc083e2ed812d5e99a8b1a738/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_433.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeFBXQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--85b7251823e0721285213bfcbde3696da3ff8967/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_449.jpg"),
        URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMWpXQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--8ea7db3f14e2c03de1093a7bb26de9cd97805838/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.12.2023_J118-WS-EX_645.jpg")
    ]
)
