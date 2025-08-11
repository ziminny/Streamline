//
//  HTTPHeaderKey.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 06/11/23.
//

import Foundation

/// Estrutura que define as chaves utilizadas para configurar cabeçalhos HTTP.
internal struct HTTPHeaderConfiguration {
    
    /// Enumeração que representa as chaves para diferentes tipos de cabeçalhos HTTP.
    enum Keys: String {
        /// Chave para o cabeçalho "Accept".
        case accept = "accept"
        
        /// Chave para o cabeçalho "Content-Type".
        case contentType = "content-type"
        
        /// Chave para o cabeçalho "User-Agent".
        case userAgent = "user-agent"
        
        /// Chave para o cabeçalho "Lang".
        case lang = "lang"
    }
    
}

