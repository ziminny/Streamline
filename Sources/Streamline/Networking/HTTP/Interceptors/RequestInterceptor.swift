//
//  RequestInterceptor.swift
//
//  Created by Vagner Oliveira on 06/06/23.
//

import Foundation

/// Protocol that defines a request interceptor.
public protocol RequestInterceptor: AnyObject where Self: Sendable {
    
    /// Intercepts and potentially modifies the URLRequest.
    ///
    /// - Parameter urlRequest: The URLRequest reference to intercept and possibly modify.
    ///
    /// - Example usage:
    ///   ```swift
    ///   intercept(with: &urlRequest)
    ///   ```
    func intercept(with urlRequest: inout URLRequest)
}


 
