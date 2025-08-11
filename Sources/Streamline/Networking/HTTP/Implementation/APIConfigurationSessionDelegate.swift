//
//  APIConfigurationSessionDelegate.swift
//  PasseiNetworking
//
//  Created by vagner reis on 13/10/24.
//

import Foundation

/// Protocol that defines the requirements for the API configuration session delegate.
protocol APIConfigurationSessionDelegate: AnyObject {
    /// URL session configuration to be used by the API.
    var configurationSession: URLSessionConfiguration { get }
    
    /// Method to check for waiting connectivity before making a request.
    ///
    /// - Parameter url: The URL for which connectivity will be checked.
    func checkWaitingForConnectivity(withURL url: URL?)
}

