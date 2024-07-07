//
//  RepositoryErrors.swift
//  Hubmee
//
//  Created by Roman Kovalchuk on 01.05.2023.
//

import Foundation
import NerdzNetworking

enum RepositoryErrors: LocalizedError {
    case unknown
    case notForUser
    case networking(message: String)
    
    init(_ error: Error) {
        if let responseError = error as? ErrorResponse<ServerErrorMessageResponse> {
            self.init(responseError)
        }
        else {
            self = .unknown
        }
    }
    
    init(_ error: ErrorResponse<ServerErrorMessageResponse>) {
        switch error {
        case .server(_, statusCode: let statusCode):
            if statusCode == .unauthorized {
                self = .notForUser
            }
            else {
                self = .networking(message: error.localizedDescription)
            }
            
        case .decoding:
            self = .networking(message: error.localizedDescription)
            
        case .system(let error):
            if (error as NSError).code == NSURLErrorTimedOut {
                self = .notForUser
            }
            else {
                self = .networking(message: error.localizedDescription)
            }
        }
    }
}
