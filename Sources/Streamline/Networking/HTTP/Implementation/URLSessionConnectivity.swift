//
//  URLSessionConnectivity.swift
//  PasseiNetworking
//
//  Created by vagner reis on 13/10/24.
//

import Foundation

/// Protocol used to communicate that the connection is waiting for connectivity in `NSAPIService`.
public protocol URLSessionConnectivity: AnyObject where Self: Sendable {
    
    /// The URL session configuration used for the connection.
    var configurationSession: URLSessionConfiguration { get }
    
    /// Checks if the connection is currently waiting for connectivity.
    /// - Parameter url: The URL associated with the task, if any.
    func checkWaitingForConnectivity(withURL url: URL?)
}

