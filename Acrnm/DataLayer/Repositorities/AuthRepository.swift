//
//  AuthRepository.swift
//  Template
//
//  Created by Vasyl Khmil on 17.03.2024.
//

import Foundation
import NerdzNetworking
import NerdzUtils

protocol AuthRepositoryType {
    
    var authToken: String? { get }
    
    func loginUser(email: String, password: String) async throws -> UserModel
}

class AuthRepository: AuthRepositoryType {
    
    @KeychainProperty("AuthRepository.authToken", initial: nil)
    private(set) var authToken: String?
    
    func loginUser(email: String, password: String) async throws -> UserModel {
        #warning("This is only for testing purposes")
        
        do {
            let request = LoginWithEmailAndPasswordRequest(email: email, password: password)
            let response = try await request.asyncExecute()
            let model = UserModel(response.user)
            
            authToken = response.token
            
            return model
        }
        catch {
            throw RepositoryErrors(error)
        }
    }
}
