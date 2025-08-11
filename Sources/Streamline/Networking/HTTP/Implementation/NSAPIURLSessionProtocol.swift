//
//  NSAPIURLSessionProtocol.swift
//  PasseiNetworking
//
//  Created by vagner reis on 13/10/24.
//

import Foundation

public protocol NSAPIURLSessionProtocol: Sendable where Self: NSObject & URLSessionTaskDelegate & URLSessionDelegate {
    static var shared: Self { get }
    var delegate: NSURLSessionConnectivity? { get set }
    var session: URLSession { get }
    var privateQueue: DispatchQueue { get }
    var certificateInterceptor: PSURLSessionLoadCertificate? { get set }
}
