//
//  Environment.swift
//  Template
//
//  Created by NerdzLab
//

import Foundation

struct Environment {

    #warning("Specify default values for every environment")
    
    static let production = Environment(
        apiBaseURLString: "https://......."
    )

    static let staging = Environment(
        apiBaseURLString: "https://......."
    )
    
    static let dev = Environment(
        apiBaseURLString: "https://......."
    )

    static var current: Environment {
        #if STAGE_ENV
        return .staging
        #elseif DEV_ENV
        return .dev
        #else
        return .production
        #endif
    }
    
    var apiBaseURL: URL {
        guard let url = URL(string: apiBaseURLString) else {
            fatalError("Base url not setup")
        }
        
        return url
    }
    
    private let apiBaseURLString: String
}
