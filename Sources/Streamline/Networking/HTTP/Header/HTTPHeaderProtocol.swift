//
//  HTTPHeaderProtocol.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

/// Protocol that defines the structure of an HTTP header.
internal protocol HTTPHeaderProtocol {
    
    /// Associated type for the header value.
    associatedtype ValueType = Any
    
    /// Value of the header.
    static var headerValue: ValueType { get }
    
    /// Key of the header.
    static var headerKey: HTTPHeaderConfiguration.Keys { get }
}


