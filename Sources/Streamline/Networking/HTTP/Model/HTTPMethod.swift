//
//  HTTPMethod.swift
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// HTTP verbs used in network requests.
///
/// This enum represents the common HTTP methods.
public enum HTTPMethod: String, Sendable {
    /// HTTP POST method.
    case POST = "POST"
    /// HTTP PUT method.
    case PUT = "PUT"
    /// HTTP GET method.
    case GET = "GET"
    /// HTTP DELETE method.
    case DELETE = "DELETE"
    
    /// Initializes an `HTTPMethod` from an optional raw string value.
    ///
    /// - Parameter rawValue: The raw string value representing the HTTP method.
    /// - Returns: An `HTTPMethod` instance if the raw value matches a known method; otherwise, `nil`.
    public init?(rawValue: String?) {
        guard let rawValue else {
            return nil
        }
        
        switch rawValue {
        case "POST":
            self = .POST
        case "PUT":
            self = .PUT
        case "GET":
            self = .GET
        case "DELETE":
            self = .DELETE
        default:
            return nil
        }
    }
}

