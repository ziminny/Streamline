//
//  NSAPIURLSession.swift.swift
//  PasseiNetworking
//
//  Created by Humberto Rodrigues on 06/11/23.
//

import Foundation
import Network

/// Classe que lida com a sessão URL para a NSAPI.
public final class NSAPIURLSession: NSObject, NSAPIURLSessionProtocol {
    
    public static let shared: NSAPIURLSession = NSAPIURLSession()
    
    public nonisolated(unsafe) var certificateInterceptor: PSURLSessionLoadCertificate?
    
    //public static let shared = NSAPIURLSession()
    
    /// Delegado para comunicação de conectividade.
    public nonisolated(unsafe) weak var delegate: NSURLSessionConnectivity?
    
    /// Sessão URL utilizada para as solicitações da NSAPI.
    public var session: URLSession {
        privateQueue.sync(flags: .barrier) {
            return URLSession(configuration: delegate?.configurationSession ?? .noBackgroundTask, delegate: self, delegateQueue: nil)
        }
    }
    
    public nonisolated let privateQueue = DispatchQueue(label: "com.NSAPIURLSession.NSURLSessionConnectivity", qos: .background)
    
    override private init() {
        super.init()
    }
    
}

extension NSAPIURLSession: URLSessionTaskDelegate, URLSessionDelegate  {
    
    /// Função chamada quando uma tarefa está esperando por conectividade.
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        privateQueue.async {
            self.delegate?.checkWaitingForConnectivity(withURL: task.response?.url)
            // Cancela a tarefa se não estiver em segundo plano
            
            if let configuration = self.delegate?.configurationSession, configuration == .noBackgroundTask {
                task.cancel()
            }
        }
    }
    
    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        
        do {
            
            if let certificateInterceptor {
                
                try certificateInterceptor.urlSession(
                    session,
                    didReceive: challenge,
                    completionHandler: completionHandler
                )
                
                return
                
            }
            
            completionHandler(.performDefaultHandling, nil)
            
        } catch {
            // Tratar esse erro
            print("Erro ao mandar o challenge", error)
            completionHandler(.performDefaultHandling, nil)
            
        }
        
    }
    
}

public extension NSURLSessionConnectivity {
    /// Configuração de sessão URL padrão quando não é uma tarefa em segundo plano.
    var configurationSession: URLSessionConfiguration { .noBackgroundTask }
}
