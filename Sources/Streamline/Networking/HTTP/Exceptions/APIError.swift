//
//  APIError.swift
//
//  Created by Vagner Oliveira on 06/06/23.
//

import Foundation

/// Error returned by the backend
///  - Attributes
///    - statusCode: The request error code
///    - message: The error message
public struct AcknowledgedByAPI: Codable, Sendable {
    public private(set) var statusCode: Int
    public private(set) var message: String
}

/// Enumeration representing the possible API-related errors.
public enum APIError: LocalizedError, Sendable {
    /// Unknown error.
    case unknownError(String? = nil)
    
    /// Informational message about the error.
    case info(String)
    
    /// Response acknowledged by the API.
    case acknowledgedByAPI(AcknowledgedByAPI)
    
    /// No Internet connection.
    case noInternetConnection
    
    public var errorDescription: String? {
        switch self {
        case .unknownError(let message):
            return message
        case .info(let message):
            return message
        case .noInternetConnection:
            return Translate.shared.message(.noInternetConnection)
        case .acknowledgedByAPI(let acknowledgedByAPI):
            return acknowledgedByAPI.message
        }
    }
}

public extension APIError {
    /// Method to handle other errors not specified in the enumeration.
    ///
    /// - Parameters:
    ///   - error: The error to be handled.
    ///   - callback: A completion block called after error handling.
    static func otherError(withError error: Error) -> APIError {
        if let error = error as NSError? {
            if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                PLMLogger.logIt("API communication error \(Self.self) \(#function)")
                return .noInternetConnection
            }
            PLMLogger.logIt("Unknown error, please try again later \(Self.self) \(#function) \(error)")
            return .unknownError(error.localizedDescription)
        }
    }
}
