//
//  HTTPHeader.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

/// Estrutura que representa os cabeçalhos HTTP utilizados em requisições.
internal struct HTTPHeader: Decodable {
    
    /// Dicionário que contém os cabeçalhos HTTP padrão.
    nonisolated(unsafe) static let headerDict: [String: Any] = {
        
        // Inicializa o dicionário com cabeçalhos padrão.
        var header: [String: Any] = [:]
        
        // Adiciona o cabeçalho User-Agent ao dicionário.
        header[UserAgent.headerKey.rawValue] = UserAgent.headerValue
        
        // Adiciona o cabeçalho Content-Type ao dicionário.
        header[ContentType.headerKey.rawValue] = ContentType.headerValue
        
        // Adiciona o cabeçalho Accept ao dicionário.
        header[Accept.headerKey.rawValue] = Accept.headerValue
        
        // Adiciona o cabeçalho Lang ao dicionário.
        header[Lang.headerKey.rawValue] = Lang.headerValue
        
        // Retorna o dicionário completo de cabeçalhos.
        return header
    }()
}

