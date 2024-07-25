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
        }
    }
    
    func removeProduct() {
        Task { [weak self] in
            guard let self else {
                return
            }
            
            await self.acrnmRepository.removeProduct(self.product)
        }
    }
}
