//
//  NSHTTPStatusCodes.swift
//  PasseiNetworking-Unit-Tests
//
//  Created by vagner reis on 13/10/24.
//

import Foundation

/// A struct representing the most common HTTP status codes.
/// This struct provides static constants for each code and includes
/// a brief description of each code's meaning.
public struct NSHTTPStatusCodes {

    /// Informational - Request received, continuing process.
    public static let continueStatus = 100
    /// Informational - Switching to a different protocol.
    public static let switchingProtocols = 101
    /// Informational - WebDAV: Processing.
    public static let processing = 102

    // MARK: - Success (2xx)

    /// Success - The request has succeeded.
    public static let ok = 200
    /// Success - The request has been fulfilled and resulted in a new resource being created.
    public static let created = 201
    /// Success - The request has been accepted for processing, but the processing has not been completed.
    public static let accepted = 202
    /// Success - Non-authoritative information returned.
    public static let nonAuthoritativeInformation = 203
    /// Success - The server successfully processed the request, but is returning no content.
    public static let noContent = 204
    /// Success - The server successfully processed the request, but is not returning any content and requires the client to reset the document view.
    public static let resetContent = 205
    /// Success - The server is delivering only part of the resource due to a range header sent by the client.
    public static let partialContent = 206
    
    /// Success range
    public static let successRange = 200..<299

    // MARK: - Redirection (3xx)

    /// Redirection - Further action needs to be taken in order to complete the request.
    public static let multipleChoices = 300
    /// Redirection - The requested resource has been assigned a new permanent URI.
    public static let movedPermanently = 301
    /// Redirection - The requested resource resides temporarily under a different URI.
    public static let found = 302
    /// Redirection - The response to the request can be found under another URI using a GET method.
    public static let seeOther = 303
    /// Redirection - The resource has not been modified since the last request.
    public static let notModified = 304
    /// Redirection - The requested resource must be accessed through the proxy given by the location field.
    public static let useProxy = 305
    /// Redirection - A temporary redirect; a new resource location is provided.
    public static let temporaryRedirect = 307

    // MARK: - Client Errors (4xx)

    /// Client Error - The server cannot or will not process the request due to an apparent client error.
    public static let badRequest = 400
    /// Client Error - The client must authenticate itself to get the requested response.
    public static let unauthorized = 401
    /// Client Error - The server understands the request but refuses to authorize it.
    public static let forbidden = 403
    /// Client Error - The server can't find the requested resource.
    public static let notFound = 404
    /// Client Error - The request method is not allowed.
    public static let methodNotAllowed = 405
    /// Client Error - The requested resource is capable of generating only content not acceptable according to the Accept headers.
    public static let notAcceptable = 406
    /// Client Error - The server timed out waiting for the request.
    public static let requestTimeout = 408
    /// Client Error - The request could not be completed due to a conflict with the current state of the resource.
    public static let conflict = 409
    /// Client Error - The requested resource is no longer available and will not be available again.
    public static let gone = 410

    // MARK: - Server Errors (5xx)

    /// Server Error - The server encountered an unexpected condition that prevented it from fulfilling the request.
    public static let internalServerError = 500
    /// Server Error - The server does not support the functionality required to fulfill the request.
    public static let notImplemented = 501
    /// Server Error - The server, while acting as a gateway or proxy, received an invalid response from the upstream server.
    public static let badGateway = 502
    /// Server Error - The server is currently unavailable (because it is overloaded or down for maintenance).
    public static let serviceUnavailable = 503
    /// Server Error - The server, while acting as a gateway or proxy, did not receive a timely response from the upstream server.
    public static let gatewayTimeout = 504
    /// Server Error - The server does not support the HTTP protocol version used in the request.
    public static let httpVersionNotSupported = 505
}
