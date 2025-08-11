//
//  APIConfiguration.swift
//  
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// Class that represents the initial API configuration.
public struct APIConfiguration: Sendable {
    
    /// Shared instance of the API configuration.
    nonisolated(unsafe) public static var shared = APIConfiguration()
    
    /// API key used in requests (optional).
    public var apiKey: String? = nil
    
    /// Delegate for configuring the API URL session.
    // internal var delegate: APIConfiguration?
    
    /// URL session configuration used by the API.
    // internal var configurationSession: URLSessionConfiguration { delegate?.configurationSession ?? .noBackgroundTask }
    
    /// API base URL.
    private(set) var baseUrl = ""
    
    /// Port used in requests (optional).
    private(set) var port: Int? = nil
    
    /// Language used for API requests.
    private(set) var language: Language = .enUS
    
    /// API connection instance using the configured URL session.
    // internal var apiConnection: APIURLSession {
    //    return APIURLSession(delegate: self)
    // }
    
    /// Method to configure the application with the base URL, port, API key, and language.
    ///
    /// - Parameters:
    ///   - baseURL: The API base URL.
    ///   - port: The port used in requests (optional).
    ///   - apiKey: The API key used in requests (optional).
    ///   - language: The language for the API (default: `.enUS`).
    public mutating func application(
        _ baseURL: String,
        _ port: Int? = nil,
        _ apiKey: String? = nil,
        _ language: Language = .enUS) {
            
        self.baseUrl = baseURL
        self.port = port
        self.apiKey = apiKey
        self.language = language
            
    }
    
    /// Private initializer method.
    // private init() { }
    
}

/// Extension that implements the `URLSessionConnectivity` protocol for the API configuration.
// extension APIConfiguration {
    /// Method to check for connectivity before performing a request.
    ///
    /// - Parameter url: The URL for which connectivity will be verified.
    // func checkWaitingForConnectivity(withURL url: URL?) {
    //     delegate?.checkWaitingForConnectivity(withURL: url)
    // }
// }
