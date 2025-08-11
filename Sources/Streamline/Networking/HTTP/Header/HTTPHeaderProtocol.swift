//
//  HTTPHeaderProtocol.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

/// Protocolo que define a estrutura de um cabeçalho HTTP.
internal protocol HTTPHeaderProtocol {
    
    /// Tipo associado para o valor do cabeçalho.
    associatedtype ValueType = Any
    
    /// Valor do cabeçalho.
    static var headerValue: ValueType { get }
    
    /// Chave do cabeçalho.
    static var headerKey: HTTPHeaderConfiguration.Keys { get }
}

