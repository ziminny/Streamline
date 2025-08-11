//
//  Lang.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 06/11/23.
//

import Foundation

/// Estrutura que representa a configuração do cabeçalho "Lang" para solicitações HTTP.
struct Lang: HTTPHeaderProtocol {
    
    /// Tipo associado que define o tipo de valor usado para o cabeçalho "Lang".
    typealias ValueType = String
    
    /// Valor do cabeçalho "Lang" obtido a partir das configurações de localização atual.
    static var headerValue: ValueType {
        return Locale.current.identifier
    }
    
    /// Chave do cabeçalho "Lang".
    ///
    /// - Returns: Um valor da enumeração `HTTPHeaderConfiguration.Keys` representando a chave "Lang".
    static var headerKey: HTTPHeaderConfiguration.Keys { .lang }
}

