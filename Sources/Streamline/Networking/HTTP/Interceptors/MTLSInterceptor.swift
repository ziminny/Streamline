//
//  MTLSInterceptor.swift
//  PasseiNetworking
//
//  Created by vagner reis on 23/10/24.
//

import Foundation

/// Protocol for intercepting and handling mTLS authentication challenges in a URLSession.
public protocol MTLSInterceptor: AnyObject {
    
    /// Handles the URLSession authentication challenge.
    ///
    /// - Parameters:
    ///   - session: The URLSession instance that received the challenge.
    ///   - challenge: The authentication challenge to respond to.
    ///   - completionHandler: The completion handler to call with the disposition and credential.
    /// - Throws: An error if the challenge handling fails.
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) throws -> Void
}

