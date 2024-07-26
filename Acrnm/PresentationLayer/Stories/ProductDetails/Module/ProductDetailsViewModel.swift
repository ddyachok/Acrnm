//
//  ProductDetailsViewModel.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 04.07.2024.
//

import Combine
import SwiftUI
import SwiftData

final class ProductDetailsViewModel: ProductDetailsViewModelType {
    
    // MARK: - Properties (public) -
    
    @Published var product: ProductModel
    @Published var isProductSaved: Bool = false
    
    // MARK: - Injects -
    
    private let acrnmRepository: AcrnmRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization -
    
    init(repository: AcrnmRepository = AcrnmRepository.shared, product: ProductModel) {
        self.acrnmRepository = repository
        self.product = product
    }
    
    // MARK: - Methods (public) -
    
    func saveProduct() {
        Task { [weak self] in
            guard let self else {
                return
            }
            
            await self.acrnmRepository.saveProduct(self.product)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching products: \(error)")
                        
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] products in
                    self?.isProductSaved.toggle()
                })
                .store(in: &cancellables)
        }
    }
    
    func removeProduct() {
        Task { [weak self] in
            guard let self else {
                return
            }
            
            await self.acrnmRepository.removeProduct(self.product)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching products: \(error)")
                        
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] products in
                    self?.isProductSaved.toggle()
                })
                .store(in: &cancellables)
        }
    }
    
    func fetchLatestProductData() {
        Task { [weak self] in
            guard let self else {
                return
            }
            
            await self.acrnmRepository.fetchSavedProduct(by: self.product.title)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error fetching products: \(error)")
                        
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] product in
                    self?.isProductSaved = product != nil
                })
                .store(in: &cancellables)
        }
    }
}
