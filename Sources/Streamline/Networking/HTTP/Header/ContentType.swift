//
//  ContentType.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

/// Structure representing the HTTP content type header.
internal struct ContentType: HTTPHeaderProtocol {
    
    /// The associated value type for the structure, which is a String for `ContentType`.
    typealias ValueType = String
    
    /// The header key, provided by the `HTTPHeaderConfiguration.Keys` enumeration.
    static var headerKey: HTTPHeaderConfiguration.Keys { .contentType }
    
    /// The header value, which is the string `"application/json"` to indicate a JSON content type.
    static var headerValue: ValueType { "application/json" }
}


