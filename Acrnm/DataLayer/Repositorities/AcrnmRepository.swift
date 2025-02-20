//
//  AcrnmRepository.swift
//  Acrnm
//
//  Created by Danylo Dyachok on 07.07.2024.
//

import Foundation
import Combine
import SwiftData

final class AcrnmRepository {
    
    // MARK: - Properties (public) -
    
    static let shared = AcrnmRepository()
    
    // MARK: - Properties (private) -
    
    let swiftDataContainer: ModelContainer = {
        let schema = Schema([ProductModel.self])
        do {
            let container = try ModelContainer(for: schema)
            return container
        }
        catch {
            fatalError("Failed to create ModelContainer")
        }
    }()
        
    // MARK: - Methods (public) -
    
    func fetchAllProductCategories() -> Future<[ProductCategoryType], Error> {
        Future { promise in
            // Simulate async operation
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                promise(.success([.showAll, .ss24, .fw2324]))
            }
        }
    }
    
    func fetchListOfProducts(for category: ProductCategoryType) -> Future<[ProductModel], Error> {
        Future { promise in
            // Simulate async operation
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let self else {
                    return
                }
                
                switch category {
                case .showAll:
                    promise(.success([
                        self.j118_ws_ex,
                        self.sp38_m,
                        self.j1wb_e,
                        self.p59_e,
                        self.s25_pr_d,
                        self.j115_gt,
                        self.ng4_ps,
                        self.sac_j6010
                    ]))
                case .ss24:
                    promise(.success([
                        self.j118_ws_ex,
                        self.sp38_m,
                        self.j1wb_e,
                        self.p59_e,
                        self.s25_pr_d
                    ]))
                case .fw2324:
                    promise(.success([
                        self.j115_gt,
                        self.ng4_ps
                    ]))
                    
                case .ss22:
                    promise(.success([
                        self.sac_j6010
                    ]))
                }
            }
        }
    }
    
    @MainActor
    func saveProduct(_ product: ProductModel) -> Future<Void, Error> {
        return Future { [weak self] promise in
            guard let self else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            // TODO: - Update to id -
            let productId = product.title
            
            let predicate = #Predicate<ProductModel> {
                $0.title == productId
            }
            
            let fetchRequest = FetchDescriptor<ProductModel>(
                predicate: predicate
            )
            
            do {
                let existingProducts = try self.swiftDataContainer.mainContext.fetch(fetchRequest)
                
                if existingProducts.isEmpty {
                    self.swiftDataContainer.mainContext.insert(product)
                    promise(.success(()))
                } 
                else {
                    promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Product already exists"])))
                }
            }
            catch {
                promise(.failure(error))
            }
        }
    }
    
    @MainActor
    func removeProduct(_ product: ProductModel) -> Future<Void, Error> {
        Future { promise in
            self.swiftDataContainer.mainContext.delete(product)
            promise(.success(()))
        }
    }
    
    @MainActor
    func fetchSavedProducts() -> Future<[ProductModel], Error> {
        Future { [weak self] promise in
            guard let self else {
                return
            }
            
            do {
                let products = try self.swiftDataContainer.mainContext.fetch(FetchDescriptor<ProductModel>())
                promise(.success(products))
            }
            catch {
                promise(.failure(error))
            }
        }
    }
    
    @MainActor
    func fetchSavedProduct(by title: String) -> Future<ProductModel?, Error> {
        Future { [weak self] promise in
            guard let self else {
                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])))
                return
            }
            
            let predicate = #Predicate<ProductModel> {
                $0.title == title
            }
            
            let fetchRequest = FetchDescriptor<ProductModel>(
                predicate: predicate
            )
            
            do {
                let products = try self.swiftDataContainer.mainContext.fetch(fetchRequest)
                promise(.success(products.first))
            } 
            catch {
                promise(.failure(error))
            }
        }
    }
    
    // MARK: - Mock data -
        
    let j118_ws_ex = ProductModel(
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
    
    let sp38_m = ProductModel(
        title: "SP38-M",
        productDescription: """
Born from the engineering requirements for a fully Acronym® dual mode pant, a new trouser form has emerged. Horizontal top-front TensionZipǽ pockets for shelf like instant access. Optimally placed TensionZipǽ cargo pockets for compact motion-stable storage. Side position zippered Deep Pocketsǽ for everything else. Hard wearing, highly breathable, mil-spec stretch nylon fabrication. High-speed low-drag active sports hardware components. Punk rock oversize fly front metal zip. SP38-M is the new state of the art.

[ Shown in size: M. Fits: STRAIGHT ]
""",
        images: [
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBODNaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--981b096c08ebe1e040af2acc9d894260896538a7/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_403.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOTdaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--b30a1bd06f3bc0b64b603866b8c6df1e83e4ea60/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234194.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBODdaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--1324651de863031cf8d4b81b752d165162be8b76/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_417.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOS9aQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--217babead01b31d5f6e590aecfcb12e7e080a6b7/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234208.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOC9aQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--8dc4a197efe3a16b30b3f410d6bba461f48cb12a/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_428.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK0RaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--e30acb9f8fdfbf107d4803fa100665752de09da4/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234217.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOURaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--4cfdadac76beb38b27cbcf52e488a8a5f39efe82/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_436.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK0xaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--744f3b3a16ae147f03d982d0475e4f7a578b72bf/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234238.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOUhaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--854c4ea14e5fef37eddfb27543dec79848d15401/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_443.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOUxaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--9319ccd7a910ee3eb38bd4739374e3c54f051b2d/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_451.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK1BaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--8c9d4e3191b2336d176db36dd5d1230ff255924d/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234243.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK2ZaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--edd473f2e66b940a65a0e708136dbcd3f5c8ffd4/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234326.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK1RaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--154b4df7388b85682961940d891cf732e28360f6/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234252.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOVBaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--dffa39a621db4dd28356c7ffb4b50ae5f05fddac/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_468.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBK2JaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--7f0eab964b985c9d4b607796c4b95d9e66efacb4/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234269.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOVRaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--bcc8f303eff037eed9d8148d8cacfbeb936c2e6e/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_476.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOXpaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--0d65757fbe3201e47714e2e84789c33b6b430979/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_547.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOVhaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--2fa5533aa26888a798de5268f4499e50ce1e51de/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_492.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOWJaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--a61157003c560c029e7fc5dff0c76a3b534d72f5/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_500.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOWpaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--e9649acdf1c8fd5ef61d65bc14a497e80bdee954/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_519.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOW5aQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--bbbb96c11a94b332cd4c54ad6cc91a46459d364c/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_525.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOXJaQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--e04d694794c1abe633c5495688b17b2c5a8661dc/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_11.12_SP38-M_540.jpg")
        ]
    )
    
    let j1wb_e = ProductModel(
        title: "J1WB-E",
        productDescription: """
Hellraiser. The legendary J1B re-summoned in microencapsulated nylon and metal. Kinetically remastered. All new original. J1B is built with nodal point weathered drone assassin math. 7 anatomic pockets allow for digital cardboard realism and sub-orbital saturation points. Interopsǽ for frictionless free-market fetishism drugs. Asymmetric DIY 3rd Arm Legba refrigerator. Removable beef noodles franchise vinyl. ǍCROŇYMř systems order-flow remains unparalleled.

[ Shown in size: M. Fits: WIDE ]
""",
        images: [
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBL3pjQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--c45fcbfcf4150bd366c33f64378e6c54151100aa/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1701.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBL1hjQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--0aa3d908a1844c428bf69fbae6b2209892dc7a3c/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1662.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBL2JjQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--bf7de224c92988d3f4a3a627b76e2e2d79610b63/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1670.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBL2ZjQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--5699661781f710c3e494bf52563476e66e3f5546/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1675.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBL2pjQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--fcde6c9d30e1e1e01caf3d17b7e619a27c7ad8d6/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1680.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBL25jQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--3e8037c38bb839ae3e6911c31e2e729f8adcce0b/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1684.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBL3JjQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--6fdf87e29952feed91e3128d97538f5b644b9c3e/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1691.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeWptQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--9be5dd687f7f7bad3bbdcec606ee13ee051c83a1/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1752.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBd1BkQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--5a4fd6d6e9b551d718dd560f6ef70d83d7897d23/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1779.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBenJnQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--2a56243634678112ccf5eeb220c539253ed0525d/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1839%201.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBenZnQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--67b4fe7d8e36568fe08b9cc762555c2a6cddcf9d/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1837%201.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMExnQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--896a30d36cc6c9975992e74104607cba9939528f/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1816%201.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMFBnQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--b58de2c53aebe4a3bc18e3d956d3bfbb1ae26144/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1814%201.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBd2pkQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--132134c7ebd12609b6e5516e8937bb471b5fde88/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1858.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeXZtQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--d7339e82e1d3a0e1dd9bf2a1591351c120cdc671/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J1WB-E_1739.jpg")
        ]
    )
    
    let p59_e = ProductModel(
        title: "P59-E",
        productDescription: """
Return of the high-postion cargo trouser. Featuring an all new TensionZipǽ pocket layout and an extra-articulated organic fit block. Newly designed detached phone pocket features a stabilizing side zipper (destabilized = open = folding pocket bag = increased retention), and removable retainer (= two methods of retention). Strategically overlapping 11 pocket array means that everything stays at hand, and that minimal energy is wasted as objects are close to the axes of motion.

[ Shown in size: M. Fits: WIDE ]
""",
        images: [
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNWtYQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--3ed3030d40e2da5ab7dfbb47731f97a156a4f3cd/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_13.03.20243159.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMmtYQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--2d17749d39aa7c0ef8bbbcf65d011a3cc54378d5/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241064.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMm9YQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--bfaaf120423d8eb04f66ee045e12e82a39d7168b/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241072.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMk1YQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--5aa3c18f528dbd928ee45467c6fad3dd991156c6/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241010.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMllYQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--7e42662611c3d321deb1f4f9801eda40e3ce0cb1/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241037.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMmdYQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--d4898c73d014ab6e2593a9cc70321453dde239c8/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241055.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMjBYQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--1a7cdfd191ffb1f9a05b1a7a6f981a1844263d73/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241106.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMjRYQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--5a42db3632a0d95c864abaaf07e3c37d01872c96/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241107.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMjhYQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--408b3476f876a5b2a155939ac711c33777133d99/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241114.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBM0lYQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--879357f4c55e03f537e1296ffe216d37e39eccae/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241154.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBM1FYQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--764ca8e3c3a74d3fa6125c51bad18dc727b90f8a/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241165.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBM1VYQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--be79d91b60f3b40cbf4beada2c0a33644cc34d2d/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241176.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNmNYQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--ba225a3bd4b939b5ee0a51796a36f3547adde0a1/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241969.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNmdYQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--1d60df2ed11e5cc97567e1c95e82680644474448/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241986.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNmtYQXc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--a6e9e1711e29dd6f4d0da6113882630b6ab88683/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_12.03.20241993.jpg")
        ]
    )
    
    let s25_pr_d = ProductModel(
        title: "S25-PR-D",
        productDescription: """
Custom fit pima cotton short sleeve t-shirt.

[ Shown in size: M. Fits: STRAIGHT ]
""",
        images: [
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeFhQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--1c60172404a5a9dcec0b55a65fd527fd3bceaa84/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234146.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBdy9QQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--587c2006396c4cd728fea5f204fe5465b0871a6a/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20233437.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeERQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--8a82accd34010f2116683b28a1896cacc4fcdb73/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20233445.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeEhQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--eb47456f8f16842ba4265c398fef9bb1fafa456c/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20233451.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeExQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--58c972d88a01954df73d5ea0a5c66a1b9b9b02ba/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20233458.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeFBQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--80f5eaf5d92bebb2e94ef5c3a5a94600edf32658/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20233469.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeFRQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--8805a5365b623b0e7e71e97d67682a6905a24c04/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20233478.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeHJQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--033fcda582ab45ba6018b79e6a358c6e233a8fbf/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234208.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeHpQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--a62b3093c979867ca3d81efc94fab5750456af50/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234227.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeGpQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--3858ece9628b9c4b40eb8dcbb3ce0f0aa90d1ae3/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234183.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeGZQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--6a7d75832afecc4ba70481a13fcf617b17247242/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234174.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeGJQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--804518cc02a8c846f9e7e8c2ca06e43c2aeb2fd8/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234148.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeUxQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--2a814a2ee5842b3ab82899c46c5303b79ed6bb39/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234277.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeVRQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--16426aa042969ca5c980f976060abec1fef2ac4e/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234292.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeVBQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--874c482ad24318bc1a0f44cfc0f178215e345e2b/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234290.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeWZQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--54d9431e2ab25bc5c965b76791de7ab6abeed248/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234299.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeVhQQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--390bab2c320b27f19279348f9a8ee954213d57de/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/ACRONYM_14.12.20234293.jpg")
        ]
    )
    
    let j115_gt = ProductModel(
        title: "J115-GT",
        productDescription: """
The industrial elegance of the asymmetric and direct. J115-GT is a blunt instrument for uncertain futures, with a feature set that is unorthodox, open-ended, and effective. Parka-like coverage means the jacket can layer over almost anything and anyone. The jacket front and collar close in multiple ways, from a barely there single snap, to double-zipped stormproof shutout. TensionZipǽ dump pockets are expandable and always at hand. Interopsǽ and the Auxiliary Zipǽ allow for modular combination, while the removable retroreflective sleeve (available in 2 color options) means you can go from being seen to unseen at will. The ZipSlingǽ ties it all together with a deployable diagonal strap.

Built with enhanced Gore-Tex® Pro most breathable technology** to provide extreme breathability—minimizing moisture buildup to give more comfort in more conditions—with retained ruggedness, uncompromised waterproof and windproof protection, and superior lightweight qualities with an improved environmental footprint.

[ **Optimized for breathability during higher-intensity activities, while retaining the ruggedness and waterproof ratings for which Gore-Tex® Pro is known. This technology newly introduces the lightest laminates ever offered in the Gore-Tex® Pro category, using 30-denier face textiles and the new solution-dyed version of the robust Micro Grid™ backer. ]

[ Shown in size: M. Fits: WIDE ]
""",
        images: [
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNFNvQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--051648fd032e78ec307d8979ec36d778f1924194/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT%20Black1295.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNFdvQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--00cfc37d22e911226c27b27df11d700d9b53c8a1/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT%20Black1302.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNUdvQWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--4031148aec9c7376f7996a9706e8af1b5e7d749a/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT%20_Black%203206.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMkwwQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--f8a68aead6097169e29e2488adf99ee5a7c07d1d/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2448_Western_Logo_Edit.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNDZWQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--d8a9e9f722b1375bbe265a27402e2e67d5737e80/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2358.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNUdWQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--85bd23eef43d25c1f165c3b562a39b93f6a9310b/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2391.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNCtWQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--90c2bd4bc2b898137a0543693d66b44bd33419ea/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2372.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBN1dWQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--5f5c37bd7e569971081d5e58bb1688d4e9b20f82/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2606.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBN2VWQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--d80c9976902fe4083620fd1b127e0bd8b03b6e33/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2618.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOGVWQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--6a077244a04d541408705d2efffb0113b2b4e1d8/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2711.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMUdaQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--a0dd0044a463ac5bd1b845467f3c48ddb8dabbd9/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2633.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNzJWQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--e3861368919bf524876fb1dee9d7ae4967a3d4b3/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2644.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNzZWQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--154842bc0c6c468e41552eabb4ca461516511772/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2653.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBOEtWQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--f16a29f1285a3d2c16037f7bccd803ff89d5e874/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2671.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMDJaQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--6129f518a2c97d388e0a5256c0e3cc164a975028/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2683.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMjcwQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--c1cb40c7524e5f550a3109a7b390fcb45b1de16d/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2693_Logo_Edit.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBN0dWQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--34270ba1420fd3e441e110043d9992dce55d6ba3/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_2586.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMStaQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--8b0ed5d70c7e2eb607a86e710c27cb9b09aa410a/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_1626_V2.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMWIwQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--8184966b32c214a3e520f5a32cd30de3ba450939/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_1599_V2_Logo_Edit.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBMWowQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--a9d0fbbb3b6d123efb2c50ad4a22fbcfcbdc68c4/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_1607_V2_Logo_Edit.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBM2lWQVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--04909573b0eab0ca2f0f06762defb62048b217da/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/J115-GT_1563.jpg")
        ]
    )
    
    let ng4_ps = ProductModel(
        title: "NG4-PS",
        productDescription: """
Zipped up, NG4's unique ergonomic pattern fully encloses face, neck, and ears for warmth and concealment. Unzipped, it drapes around the neck like a scarf; the weight of the size 8 metal zipper naturally holding it in place. As unorthodox as it is effective. Gen 1.2 features a revised pattern and construction to decrease fabric waste, and an AuxZip ( M ) to ( M ) adapter zip, allowing it to be docked to both shell and liner garments for the first time.

Can be worn inside/under jackets with large collars and hoods, or outside/over jackets with short/no collars.

The very elastic and incredibly cozy Polartec® Powerstretch™ fabric radiates comfort across your entire microclimate.


""",
        images: [
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeVB4QVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--1ebadc389e83db29620712c0f4383f1e8745509e/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/NG4-PS_2902.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeW54QVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--15edeef23d12b43a6223ed2a3d9c5abf4640812f/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/NG4-PS_2934.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeWp4QVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--5fb190d741b0cc2de4566adc253cb702e09cffc3/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/NG4-PS_2927.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBNXR3QWc9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--411941692d69998a35c7f263898714b0a40133b5/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/NG4-PS_2917%20(1).jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBemp4QVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--8ce74a5f719944b16db1d3e29a44d8da587629e1/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/NG4-PS_3022.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeVR4QVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--231e77fb864f9e69eea4a600d686ca19a8ebe28a/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/NG4-PS_2912.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeDd4QVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--d225cd828c717a02bf2d57bf9e75d1aaf46c103b/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/NG4-PS_2889.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeC94QVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--c8677c0830e816e79ff5ab0ca9501b9a992c78d9/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/NG4-PS_2893.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBeUx4QVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--bb0a802df2b5a6c211287d7644630febca45dbcb/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/NG4-PS_2900.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBelB4QVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--599f659901d1f43dd0ef9815b0a7f05028006c51/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/NG4-PS_2986.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBelR4QVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--981807d08cbf04f62a6927a3038bfd8c8d05f15c/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/NG4-PS_2989.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBelh4QVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--81ec52df9c533b56be3a96996a760630409a707e/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/NG4-PS_2993.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBemZ4QVE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--187b0409ead5fbef6f28f8ac8603a99e4bfe8a4d/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/NG4-PS_3016.jpg")
        ]
    )
    
    let sac_j6010 = ProductModel(
        title: "SAC-J6010",
        productDescription: """
J6010 is sacai's aesthetic reframing of the Acronym J1W-GTPL design**. Following sacai methodology, it preserves hallmark attributes while fundamentally altering volume, silhouette, and typology. A trench coat and dress hybrid, it features a complex multilayer design. A vest-like top layer rests above a sleeveless coat-like under layer which descends to full dress length. Made in Japan by sacai.

Shown in size: 1/S (Fa', 180 cm)

[ Fits: STRAIGHT ]

**sacai man 2022 Spring & Summer, women's 2022 Pre Spring collection

Riffing on a theme of bonding, both as a metaphor for unity and as a technique for joining together two materials - two ideas that have been at the heart of sacai since the beginning. The collection by founder and designer, Chitose Abe, is a study on sealing together two apparently disparate notions to make a new form, bringing together characteristics born of different, sometimes opposing, origins.

The ultimate expression of the idea comes courtesy of a collaboration with ACRONYM®, combining the designer Errolson Hugh's signature technical details with sacai fabrics and shapes for men and women, and, for the first time for ACRONYM®, a dress silhouette. Hugh says, 'Having known Chitose, and of course sacai, for many years, this collaboration is the ideal kind of crosspollination. And as I believe you can see from the results, it's a true blend of the philosophies of both brands, where the sum is greater than the parts.'


""",
        images: [
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBcXF1IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--597fbb97a7074d631e465cc4d5f1c9d1fc600496/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/2022_01_17-19_ACRxSacai_Trench_Dress_BLK_0010.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBdUswIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--29099a250214f94b7e3d1e685a89a6638e956bda/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/2022_01_17-19_ACRxSacai_Trench_Dress_Alpha_0003.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBdU8wIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f74ace1b5b04bbf77108268cdc1bc63bdbe1a483/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/2022_01_17-19_ACRxSacai_Trench_Dress_Alpha_0012.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBdVMwIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d534f112aef98a6820bd7eee419bae2586f30e98/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/2022_01_17-19_ACRxSacai_Trench_Dress_Alpha_0013.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBdVcwIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--bf3b19a6bb74d7a51b46053feda4ff48f92738e7/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/2022_01_17-19_ACRxSacai_Trench_Dress_Alpha_0019.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBdlMwIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--dc7b4f41a5977d109d275631c852d771ae0dde69/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/2022_01_17-19_ACRxSacai_Trench_Dress_Alpha_0114.jpg"),
            URL(string: "https://acrnm.com/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBck91IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--12a49092d7d9947578a0d9a53d5e97d402e77bda/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdDRG9MWm05eWJXRjBPZ2wzWldKd09oUnlaWE5wZW1WZmRHOWZiR2x0YVhSYkIya0NHQlZwQWhnVk9neGpiMjUyWlhKME93WT0iLCJleHAiOm51bGwsInB1ciI6InZhcmlhdGlvbiJ9fQ==--ea30ca935852b1885f58cc661c3d48e5801bfc95/2022_01_17-19_ACRxSacai_Trench_Dress_BLK_0081.jpg")
        ]
    )
}
