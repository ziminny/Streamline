//
//  HTTPServiceFactory.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 13/11/23.
//

import Foundation

public protocol HTTPServiceFactoryProtocol where Self: Sendable {
    func makeHttpService(apiURLSession: APIURLSessionProtocol) -> APIService
    func makeSocketService() -> LCSocketManager
}

extension HTTPServiceFactoryProtocol {
    
    public func makeHttpService(apiURLSession: APIURLSessionProtocol = APIURLSession.shared) -> APIService {
        
        let apiRequester = APIRequester(apiURLSession: apiURLSession)
        let http = APIService(apiRequester: apiRequester)
        
        return http
        
    }
    
}

/// Implementação padrão da fábrica de serviços HTTP.
public struct HTTPServiceFactory: Sendable, HTTPServiceFactoryProtocol {
    
    public init() {}
    
    public func makeSocketService() -> LCSocketManager {
        let socket = LCSocketManager.shared
        return socket
    }
    
}


