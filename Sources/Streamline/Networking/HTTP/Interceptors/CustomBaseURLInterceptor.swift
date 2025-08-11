//
//  CustomBaseURLInterceptor.swift
//  
//
//  Created by Vagner Oliveira on 03/07/23.
//

import Foundation

/// Protocol used to intercept and customize the base URL in NSAPI.
public protocol CustomBaseURLInterceptor: AnyObject where Self: Sendable {
    
    /// The base URL to be used in API requests.
    var baseURL: String { get set }
    
    /// The port to be used in the base URL, if applicable.
    var port: Int? { get set }
}

public extension CustomBaseURLInterceptor {
    
    /// Default value for the port if not explicitly provided.
    var port: Int? { nil }
}

