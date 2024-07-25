//
//  SavedProductsViewModelType.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 25.07.2024.
//

import Foundation

protocol SavedProductsViewModelType: ObservableObject {
    var products: [ProductModel] { get }
    
    func getSavedProducts()
    func removeProduct(_ product: ProductModel)
}
