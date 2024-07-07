//
//  LoginWithEmailAndPasswordRequest.swift
//  Template
//
//  Created by Vasyl Khmil on 17.03.2024.
//

import Foundation
import NerdzNetworking

struct LoginWithEmailAndPasswordRequest: Request {
    #warning("Rewrite or delete this request. Used for example purposes")
    
    typealias ResponseObjectType = AuthResponse
    typealias ErrorType = ServerErrorMessageResponse
    
    let path: String = "v1/api/login"
    let method: HTTPMethod = .post
    let body: RequestBody?
    
    init(email: String, password: String) {
        body = .params(
            [
                "email": email,
                "password": password
            ]
        )
    }
}
