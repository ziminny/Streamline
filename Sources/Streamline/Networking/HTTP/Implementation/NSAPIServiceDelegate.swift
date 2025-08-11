//
//  NSAPIServiceDelegate.swift
//  PasseiNetworking
//
//  Created by vagner reis on 13/10/24.
//

import Foundation

/// Um protocolo que define as propriedades e métodos necessários para a configuração e manipulação de serviços de API.
public protocol NSAPIServiceDelegate: AnyObject where Self: Sendable {
    
    /// A configuração de sessão URLSession a ser usada para os serviços de API.
    var configurationSession: URLSessionConfiguration { get }
    
    /// Executa uma ação específica quando a rede não está disponível.
    /// - Parameter url: A URL associada à ação, caso seja relevante.
    func networkUnavailableAction(withURL url: URL?)
}
