//
//  NSMTLSInterceptor.swift
//  PasseiNetworking
//
//  Created by vagner reis on 23/10/24.
//

import Foundation

public protocol NSMTLSInterceptor: AnyObject {
    func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) throws -> Void

}
