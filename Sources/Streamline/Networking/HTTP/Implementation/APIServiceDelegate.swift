//
//  APIServiceDelegate.swift
//  PasseiNetworking
//
//  Created by vagner reis on 13/10/24.
//

import Foundation

/// A protocol that defines the properties and methods required for configuring and handling API services.
public protocol APIServiceDelegate: AnyObject where Self: Sendable {
    
    /// The URLSession configuration to be used for the API services.
    var configurationSession: URLSessionConfiguration { get }
    
    /// Executes a specific action when the network is unavailable.
    /// - Parameter url: The URL associated with the action, if relevant.
    func networkUnavailableAction(withURL url: URL?)
}

