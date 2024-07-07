//
//  AuthResponse.swift
//  Template
//
//  Created by Vasyl Khmil on 17.03.2024.
//

import Foundation

struct AuthResponse: Codable {
    #warning("Respecify or delete this response. It is as an example")
    let user: UserResponse
    let token: String
}
