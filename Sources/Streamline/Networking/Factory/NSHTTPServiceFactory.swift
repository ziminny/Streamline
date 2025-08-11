//
//  NSHTTPServiceFactory.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 13/11/23.
//

import Foundation

public protocol NSHTTPServiceFactoryProtocol where Self: Sendable {
    func makeHttpService(apiURLSession: NSAPIURLSessionProtocol) -> NSAPIService
    func makeSocketService() -> NSSocketManager
}

extension NSHTTPServiceFactoryProtocol {
    
    public func makeHttpService(apiURLSession: NSAPIURLSessionProtocol = NSAPIURLSession.shared) -> NSAPIService {
        
        let apiRequester = NSAPIRequester(apiURLSession: apiURLSession)
        let http = NSAPIService(apiRequester: apiRequester)
        
        return http
        
    }
    
}

/// Implementação padrão da fábrica de serviços HTTP.
public struct NSHTTPServiceFactory: Sendable, NSHTTPServiceFactoryProtocol {
    
    public init() {}
    
    public func makeSocketService() -> NSSocketManager {
        let socket = NSSocketManager.shared
        return socket
    }
    
}


