//
//  NSHTTPMethod.swift
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// Verbos http
/// Esse enum trás todos os metodos https
public enum NSHTTPMethod: String, Sendable {
    case POST = "POST"
    case PUT = "PUT"
    case GET = "GET"
    case DELETE = "DELETE"
    
    public init?(rawValue: String?) {
        
        guard let rawValue else {
            return nil
        }
        
        switch rawValue {
        case "POST" :
            self = .POST
        case "PUT" :
            self = .PUT
        case "GET" :
            self = .GET
        case "DELETE" :
            self = .DELETE
        default:
            return nil
            
        }
    }
}
