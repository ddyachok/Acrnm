//
//  ServerErrorMessageResponse.swift
//  Template
//
//  Created by NerdzLab
//

import Foundation
import NerdzNetworking

struct ServerErrorMessageResponse: Codable, ServerError {
    let message: String
}
