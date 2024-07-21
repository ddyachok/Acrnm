//
//  ProductsListViewModel.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 07.07.2024.
//

import Combine
import SwiftUI

final class ProductsListViewModel: ProductsListViewModelType, ObservableObject {
    
    // MARK: - Properties (public) -
    
    @Published var categories: [ProductCategoryType] = [.showAll, .ss24, .fw2324]
    @Published var selectedCategory: ProductCategoryType = .showAll
    @Published var products: [ProductModel] = []
    
    // MARK: - Injects -
    
    private let acrnmRepository: AcrnmRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization -
    
    init(repository: AcrnmRepository = AcrnmRepository.shared) {
        self.acrnmRepository = repository
    }
    
    // MARK: - Methods (public) -
    
    func selectCategory(_ category: ProductCategoryType) {
        selectedCategory = category
        getProducts()
    }
    
    func getProducts() {
        acrnmRepository.fetchListOfProducts(for: selectedCategory)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Error fetching products: \(error)")
                    
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] products in
                self?.products = products
            })
            .store(in: &cancellables)
    }
}

