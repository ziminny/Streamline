//
//  NSURLSessionConnectivity.swift
//  PasseiNetworking
//
//  Created by vagner reis on 13/10/24.
//

import Foundation

/// Protocolo utilizado para comunicar que a conexão está sendo aguardada pela `NSAPIService`.
public protocol NSURLSessionConnectivity: AnyObject where Self: Sendable {
    /// Configuração de sessão URL para a conexão.
    var configurationSession: URLSessionConfiguration { get }
    
    /// Verifica se a conexão está aguardando conectividade.
    /// - Parameter url: URL associada à tarefa.
    func checkWaitingForConnectivity(withURL url: URL?)
}
