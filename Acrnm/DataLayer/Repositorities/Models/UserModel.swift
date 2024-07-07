//
//  UserModel.swift
//  Template
//
//  Created by Vasyl Khmil on 17.03.2024.
//

import Foundation

struct UserModel {
    let id: Int
    let name: String?
    
    init(_ response: UserResponse) {
        self.id = response.id
        self.name = response.name
    }
}
