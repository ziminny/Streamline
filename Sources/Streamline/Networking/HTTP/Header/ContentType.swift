//
//  ContentType.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

/// Estrutura que representa o tipo de conteúdo HTTP para cabeçalho.
internal struct ContentType: HTTPHeaderProtocol {
    
    /// O tipo de valor associado à estrutura, que é uma String no caso do ContentType.
    typealias ValueType = String
    
    /// A chave do cabeçalho, que é fornecida pela enumeração HTTPHeaderConfiguration.Keys.
    static var headerKey: HTTPHeaderConfiguration.Keys { .contentType }
    
    /// O valor do cabeçalho, que é a string "application/json" para indicar o tipo de conteúdo JSON.
    static var headerValue: ValueType { "application/json" }
}

