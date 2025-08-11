//
//  QueryString.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 25/12/23.
//

/// Enumeration representing possible keys for query string parameters in a request.
public enum QueryString: String, Sendable {
    
    /// Key for specifying the page number in pagination.
    case page = "page"
    
    /// Key for specifying the limit of items per page in pagination.
    case limit = "limit"
    
    /// Key for specifying the sorting criteria.
    case sortBy = "sortBy"
    
    /// Key for performing a general search.
    case search = "search"
    
    /// Key for performing a search by an undefined or custom type.
    case searchBy = "undefined"
    
    /// Key for applying filters to the query.
    case filter = "filter"
    
    /// Key for selecting specific fields in the response.
    case select = "select"
}


