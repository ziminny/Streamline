//
//  Accept.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

/// Implementation of the `HTTPHeaderProtocol` for configuring the "Accept" header.
class Accept: HTTPHeaderProtocol {
    
    /// Associated type for the header value.
    typealias ValueType = String
    
    /// The "Accept" header key as defined in the `HTTPHeaderConfiguration.Keys` enumeration.
    static var headerKey: HTTPHeaderConfiguration.Keys { .accept }
    
    /// Default value for the "Accept" header.
    static var headerValue: ValueType { "application/json" }
}


