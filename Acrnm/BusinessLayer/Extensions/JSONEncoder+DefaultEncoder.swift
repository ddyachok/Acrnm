//
//  JSONEncoder+DefaultEncoder.swift
//  Template
//
//  Created by NerdzLab
//

import Foundation

extension JSONEncoder {
    static let defaultEncoder: JSONEncoder = {
        let encoder = JSONEncoder()
        return encoder
    }()
}
