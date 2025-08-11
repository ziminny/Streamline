//
//  Accept.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

/// Implementação do protocolo `HTTPHeaderProtocol` para a configuração do cabeçalho "Accept".
class Accept: HTTPHeaderProtocol {
    
    /// Tipo associado para o valor do cabeçalho.
    typealias ValueType = String
    
    /// Chave do cabeçalho "Accept" conforme definido na enumeração `HTTPHeaderConfiguration.Keys`.
    static var headerKey: HTTPHeaderConfiguration.Keys { .accept }
    
    /// Valor padrão para o cabeçalho "Accept".
    static var headerValue: ValueType { "application/json" }
}

