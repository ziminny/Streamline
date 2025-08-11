//
//  Lang.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 06/11/23.
//

import Foundation

/// Structure representing the configuration of the "Lang" header for HTTP requests.
struct Lang: HTTPHeaderProtocol {
    
    /// Associated type defining the value type used for the "Lang" header.
    typealias ValueType = String
    
    /// Value of the "Lang" header obtained from the current locale settings.
    static var headerValue: ValueType {
        return Locale.current.identifier
    }
    
    /// Key of the "Lang" header.
    ///
    /// - Returns: A value of the `HTTPHeaderConfiguration.Keys` enumeration representing the "Lang" key.
    static var headerKey: HTTPHeaderConfiguration.Keys { .lang }
}


