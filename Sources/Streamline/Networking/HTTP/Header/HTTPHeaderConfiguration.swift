//
//  HTTPHeaderKey.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 06/11/23.
//

import Foundation

/// Structure that defines the keys used to configure HTTP headers.
internal struct HTTPHeaderConfiguration {
    
    /// Enumeration that represents the keys for different types of HTTP headers.
    enum Keys: String {
        /// Key for the "Accept" header.
        case accept = "accept"
        
        /// Key for the "Content-Type" header.
        case contentType = "content-type"
        
        /// Key for the "User-Agent" header.
        case userAgent = "user-agent"
        
        /// Key for the "Lang" header.
        case lang = "lang"
    }
    
}


