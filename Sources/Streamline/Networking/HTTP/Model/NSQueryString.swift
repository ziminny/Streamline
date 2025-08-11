//
//  Lang.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 25/12/23.
//

/// Enumeração que representa chaves possíveis para parâmetros de consulta (query string) em uma requisição.
public enum NSQueryString: String, Sendable {
    
    /// Chave para especificar o número da página.
    case page = "page"
    
    /// Chave para especificar o limite de itens por página.
    case limit = "limit"
    
    /// Chave para especificar a ordenação.
    case sortBy = "sortBy"
    
    /// Chave para realizar uma pesquisa.
    case search = "search"
    
    /// Chave para realizar uma pesquisa por tipo não definido.
    case searchBy = "undefined"
    
    /// Chave para aplicar filtros.
    case filter = "filter"
    
    /// Chave para selecionar campos específicos.
    case select = "select"
}

