//
//  SocketConfiguration.swift
//  AppAuth
//
//  Created by Vagner Oliveira on 07/02/24.
//

import Foundation 

/// Configuration for a socket connection, including authentication token, server URL, and optional port.
public class SocketConfiguration {
    
    /// The authentication token used for the socket connection.
    internal let token: String
    
    /// The URL of the socket server.
    internal let url: String
    
    /// The optional port number for the socket connection.
    internal let port: Int?
    
    /// Initializes a new `SocketConfiguration`.
    ///
    /// - Parameters:
    ///   - token: The authentication token to use for the socket connection.
    ///   - url: The base URL of the socket server.
    ///   - port: An optional port number to connect to. If `nil`, the default port will be used.
    public init(token: String, url: String, port: Int?) {
        self.token = token
        self.url = url
        self.port = port
    }
}

