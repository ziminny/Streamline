//
//  Parameters.swift
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// Represents all parameters required for an API request.
///
/// - Attributes:
///   - method: The HTTP verb for the request (e.g., `.GET`, `.POST`, `.DELETE`, `.PUT`).
///   - httpRequest: The request body model to be sent, used for non-GET methods.
///   - path: The path appended to the base URL. For example, if the base URL is `http://example.com/cars`, the path could be `"cars"`.
///   - queryString: A dictionary representing URL query parameters appended after the path. For example, for URL `http://example.com/cars?type=sedan`, the query string would be `["type": "sedan"]`.
///   - param: An optional parameter, usually used for URL path variables or identifiers.
///
/// Example:
/// ```swift
/// let params = Parameters(
///     method: .GET,
///     path: "cars",
///     queryString: [.type: "sedan"],
///     param: nil
/// )
/// ```
public struct Parameters: @unchecked Sendable {
    
    /// The HTTP method of the request.
    public let method: HTTPMethod
    
    /// The request body model, used for methods other than GET.
    public let httpRequest: Model?
    
    /// The path component appended to the base URL.
    public let path: RawValue
    
    /// URL query parameters appended to the URL after the path.
    public let queryString: [QueryString: Any]
    
    /// Optional parameter for path variables or identifiers.
    public let param: Any?
    
    /// Initializes a new `Parameters` instance.
    ///
    /// - Parameters:
    ///   - method: The HTTP method to use. Defaults to `.GET`.
    ///   - httpRequest: The request body model, only applicable for non-GET requests.
    ///   - path: The path component for the URL.
    ///   - queryString: Dictionary of query parameters. Defaults to empty.
    ///   - param: Optional path parameter.
    public init(
        method: HTTPMethod = .GET,
        httpRequest: Model? = nil,
        path: RawValue,
        queryString: [QueryString: Any] = [:],
        param: Any? = nil
    ) {
        self.method = method
        self.httpRequest = (method == .GET) ? nil : httpRequest
        self.path = path
        self.queryString = queryString
        self.param = param
    }
}
