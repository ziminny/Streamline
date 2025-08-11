//
//  NSPagination.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 25/12/23.
//

import Foundation

/// Modelo que representa metadados para paginação.
public struct NSMetadata: NSModel {
    
    public let itemsPerPage: Int?
    public let totalItems: Int?
    public let currentPage: Int?
    public let totalPages: Int?
    public let sortBy: Array<Array<String>?>?
    
    /// Inicializador da classe NSMetadata.
    /// - Parameters:
    ///   - itemsPerPage: Número de itens por página.
    ///   - totalItems: Total de itens disponíveis.
    ///   - currentPage: Página atual.
    ///   - totalPages: Total de páginas.
    ///   - sortBy: Opções de classificação.
    public init(itemsPerPage: Int? = nil, totalItems: Int? = nil, currentPage: Int? = nil, totalPages: Int? = nil, sortBy: Array<Array<String>?>? = nil) {
        self.itemsPerPage = itemsPerPage
        self.totalItems = totalItems
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.sortBy = sortBy
    }
    
}

/// Modelo que representa links para diferentes páginas.
public final class NSLinks: NSModel {
    
    public let first: String?
    public let previous: String?
    public let current: String?
    public let next: String?
    public let last: String?
    
    /// Inicializador da classe NSLinks.
    /// - Parameters:
    ///   - first: Link para a primeira página.
    ///   - previous: Link para a página anterior.
    ///   - current: Link para a página atual.
    ///   - next: Link para a próxima página.
    ///   - last: Link para a última página.
    public init(first: String? = nil, previous: String? = nil, current: String? = nil, next: String? = nil, last: String? = nil) {
        self.first = first
        self.previous = previous
        self.current = current
        self.next = next
        self.last = last
    }
}

/// Modelo que representa dados paginados.
public final class NSPagination<T: NSModel>: NSModel {
    
    public let data: Array<T>?
    public let meta: NSMetadata?
    public let links: NSLinks?
    
    /// Inicializador da classe NSPagination.
    /// - Parameters:
    ///   - data: Array de modelos paginados.
    ///   - meta: Metadados da paginação.
    ///   - links: Links para diferentes páginas.
    public init(data: Array<T>? = nil, meta: NSMetadata? = nil, links: NSLinks? = nil) {
        self.data = data
        self.meta = meta
        self.links = links
    }
      
}

