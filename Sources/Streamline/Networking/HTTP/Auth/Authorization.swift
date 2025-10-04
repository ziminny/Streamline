//
//  Authorization.swift
//  
//
//  Created by Vagner Oliveira on 06/06/23.
//

import Foundation

public enum AuthorizationErrorCodes: Error {
    case unauthorized
    case certificateError
}

/// API Authorization
public protocol Authorization: AnyObject where Self: Sendable {
    
    /// Retrieves the refresh token and injects it into the request
    ///  - Model.Type: Return class
    ///  - Parameters: Request parameters
    func refreshToken<T: Model>(statusCode: AuthorizationErrorCodes, completion: @escaping (Model.Type, Parameters) async throws -> Model) async throws -> T
    
    func save(withData data: Data, statusCode: AuthorizationErrorCodes)
}

