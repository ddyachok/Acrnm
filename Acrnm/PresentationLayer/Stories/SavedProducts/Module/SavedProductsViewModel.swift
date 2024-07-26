//
//  SavedProductsViewModel.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 25.07.2024.
//

import Combine
import SwiftUI

final class SavedProductsViewModel: SavedProductsViewModelType, ObservableObject {
    
    // MARK: - Properties (public) -
    
    @Published var products: [ProductModel] = []
    
    // MARK: - Injects -
    
    private let acrnmRepository: AcrnmRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization -
    
    init(repository: AcrnmRepository = AcrnmRepository.shared) {
        self.acrnmRepository = repository
    }
    
    // MARK: - Methods (public) -
    
    @MainActor 
    func getSavedProducts() {
        acrnmRepository.fetchSavedProducts()
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
    
    func removeProduct(_ product: ProductModel) {
        Task { [weak self] in
            guard let self else {
                return
            }
            
            await self.acrnmRepository.removeProduct(product)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching products: \(error)")
                        
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] _ in
                    self?.products.removeAll(where: { $0.title == product.title })
                })
                .store(in: &cancellables)
        }
    }
}
