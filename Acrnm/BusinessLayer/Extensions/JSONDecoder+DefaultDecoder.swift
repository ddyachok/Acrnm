//
//  JSONDecoder+DefaultDecoder.swift
//  Template
//
//  Created by NerdzLab
//

import Foundation

extension JSONDecoder {
    static let defaultDecoder: JSONDecoder = {
        let coder = JSONDecoder()
        coder.keyDecodingStrategy = .convertFromSnakeCase
        return coder
    }()
}
