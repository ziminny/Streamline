//
//  APIURLSessionProtocol.swift
//  PasseiNetworking
//
//  Created by vagner reis on 13/10/24.
//

import Foundation

/// Protocol defining requirements for a URL session used by the API.
public protocol APIURLSessionProtocol: Sendable where Self: NSObject & URLSessionTaskDelegate & URLSessionDelegate {
    
    /// Shared singleton instance of the conforming type.
    static var shared: Self { get }
    
    /// Delegate to handle connectivity-related events.
    var delegate: URLSessionConnectivity? { get set }
    
    /// URLSession instance used for performing requests.
    var session: URLSession { get }
    
    /// Private dispatch queue for synchronizing internal operations.
    var privateQueue: DispatchQueue { get }
    
    /// Optional interceptor for handling certificate challenges.
    var certificateInterceptor: PSURLSessionLoadCertificate? { get set }
}

