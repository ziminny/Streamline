//
//  Pagination.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 25/12/23.
//

import Foundation

/// Model representing metadata for pagination.
public struct Metadata: Model {
    
    /// Number of items per page.
    public let itemsPerPage: Int?
    
    /// Total number of available items.
    public let totalItems: Int?
    
    /// Current page number.
    public let currentPage: Int?
    
    /// Total number of pages.
    public let totalPages: Int?
    
    /// Sorting options, represented as an array of arrays of strings.
    public let sortBy: [[String]?]?
    
    /// Initializes a new `Metadata` instance.
    ///
    /// - Parameters:
    ///   - itemsPerPage: Number of items per page.
    ///   - totalItems: Total number of available items.
    ///   - currentPage: Current page number.
    ///   - totalPages: Total number of pages.
    ///   - sortBy: Sorting options.
    public init(
        itemsPerPage: Int? = nil,
        totalItems: Int? = nil,
        currentPage: Int? = nil,
        totalPages: Int? = nil,
        sortBy: [[String]?]? = nil
    ) {
        self.itemsPerPage = itemsPerPage
        self.totalItems = totalItems
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.sortBy = sortBy
    }
}

/// Model representing pagination links.
public final class Links: Model {
    
    /// Link to the first page.
    public let first: String?
    
    /// Link to the previous page.
    public let previous: String?
    
    /// Link to the current page.
    public let current: String?
    
    /// Link to the next page.
    public let next: String?
    
    /// Link to the last page.
    public let last: String?
    
    /// Initializes a new `Links` instance.
    ///
    /// - Parameters:
    ///   - first: Link to the first page.
    ///   - previous: Link to the previous page.
    ///   - current: Link to the current page.
    ///   - next: Link to the next page.
    ///   - last: Link to the last page.
    public init(
        first: String? = nil,
        previous: String? = nil,
        current: String? = nil,
        next: String? = nil,
        last: String? = nil
    ) {
        self.first = first
        self.previous = previous
        self.current = current
        self.next = next
        self.last = last
    }
}

/// Generic model representing paginated data.
public final class Pagination<T: Model>: Model {
    
    /// Array of paginated models.
    public let data: [T]?
    
    /// Metadata about the pagination.
    public let meta: Metadata?
    
    /// Links to navigate between pages.
    public let links: Links?
    
    /// Initializes a new `Pagination` instance.
    ///
    /// - Parameters:
    ///   - data: Array of paginated models.
    ///   - meta: Pagination metadata.
    ///   - links: Pagination navigation links.
    public init(data: [T]? = nil, meta: Metadata? = nil, links: Links? = nil) {
        self.data = data
        self.meta = meta
        self.links = links
    }
}
