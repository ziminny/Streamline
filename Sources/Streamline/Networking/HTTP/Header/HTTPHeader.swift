//
//  HTTPHeader.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

/// Structure representing the HTTP headers used in requests.
internal struct HTTPHeader: Decodable {
    
    /// Dictionary containing the default HTTP headers.
    nonisolated(unsafe) static let headerDict: [String: Any] = {
        
    // Initializes the dictionary with default headers.
    var header: [String: Any] = [:]
    
    // Adds the User-Agent header to the dictionary.
    header[UserAgent.headerKey.rawValue] = UserAgent.headerValue
    
    // Adds the Content-Type header to the dictionary.
    header[ContentType.headerKey.rawValue] = ContentType.headerValue
    
    // Adds the Accept header to the dictionary.
    header[Accept.headerKey.rawValue] = Accept.headerValue
    
    // Adds the Lang header to the dictionary.
    header[Lang.headerKey.rawValue] = Lang.headerValue
    
    // Returns the complete headers dictionary.
    return header
    }()
}


