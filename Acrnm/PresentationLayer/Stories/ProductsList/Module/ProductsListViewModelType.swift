//
//  ProductsListViewModelType.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 07.07.2024.
//

import Foundation

protocol ProductsListViewModelType: ObservableObject {
    var categories: [ProductCategoryType] { get }
    var selectedCategory: ProductCategoryType { get set }
    
    var products: [ProductModel] { get }
    
    func selectCategory(_ category: ProductCategoryType)
    func getProducts()
}
