//
//  ProductDetailsViewModelType.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 06.07.2024.
//

import Foundation

protocol ProductDetailsViewModelType: ObservableObject {
    var product: ProductModel { get }
    
    func saveProduct()
    func removeProduct()
}
