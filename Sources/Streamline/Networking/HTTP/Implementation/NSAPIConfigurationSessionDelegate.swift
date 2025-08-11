//
//  NSAPIConfigurationSessionDelegate.swift
//  PasseiNetworking
//
//  Created by vagner reis on 13/10/24.
//

import Foundation

/// Protocolo que define os requisitos para o delegado de sessão de configuração da API.
protocol NSAPIConfigurationSessionDelegate: AnyObject {
    /// Configuração da sessão de URL que será utilizada pela API.
    var configurationSession: URLSessionConfiguration { get }
    
    /// Método para verificar a espera pela conectividade antes de realizar uma solicitação.
    ///
    /// - Parameter url: A URL para a qual a conectividade será verificada.
    func checkWaitingForConnectivity(withURL url: URL?)
}
