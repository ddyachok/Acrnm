//
//  ProductsListViewModel.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 07.07.2024.
//

import Combine
import SwiftUI
import NerdzInject

final class ProductsListViewModel: ProductsListViewModelType {
    
    
    // MARK: - Properties (public) -
    
    var categories: [ProductCategoryType] = []
    var selectedCategory: ProductCategoryType? = nil
    
    @Published var products: [ProductModel] = []
        
    // MARK: - Injects -
    
    @ForceInject private var acrnmRepository: AcrnmRepository
    
    // MARK: - Methods (public) -
    
    func selectCategory(_ category: ProductCategoryType) {
        selectedCategory = category
    }
    
    func getProducts() {
        Task { [weak self] in
            guard let self else {
                return
            }
            
            guard let selectedCategoryType = self.selectedCategory else {
                return
            }
            
            guard let products = try? await self.acrnmRepository.fetchListOfProducts(for: selectedCategoryType) else {
                return
            }
            
            self.products = products
        }
    }
}
