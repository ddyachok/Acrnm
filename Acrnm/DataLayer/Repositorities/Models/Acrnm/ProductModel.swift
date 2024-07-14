//
//  ProductModel.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 07.07.2024.
//

import Foundation
import SwiftData

enum ProductCategoryType: CaseIterable {
    case showAll
    case ss24
    case fw2324
}

typealias ProductAction = (ProductModel) -> Void

//@Model
final class ProductModel {
    var id: UUID
    var title: String
    var productDescription: String
    var images: [URL?]
    
    init(title: String, productDescription: String, images: [URL?]) {
        self.id = UUID()
        self.title = title
        self.productDescription = productDescription
        self.images = images
    }
}
