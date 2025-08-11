//
//  MakeRequest.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 06/02/24.
//

import Foundation

/// Responsible for constructing and sending API requests.
final internal class MakeRequest {
     
    /// Global API configuration instance.
    internal var configuration: APIConfiguration { APIConfiguration.shared }

    /// Port number for API connection (optional).
    private var port: Int? { configuration.port }

    /// Base URL string for API requests.
    private var baseURL: String { configuration.baseUrl }

    /// API key for authentication (optional).
    private var apiKey: String? { configuration.apiKey }
    
    /// The API URL session to be used for network calls.
    internal var apiURLSession: APIURLSessionProtocol
    
    /// Optional interceptor for modifying requests before sending.
    internal weak var interceptor: RequestInterceptor?
    
    /// Optional interceptor to customize the base URL.
    internal weak var baseURLInterceptor: CustomBaseURLInterceptor?
    
    /// Initializes the MakeRequest instance with a URL session.
    /// - Parameter apiURLSession: The API URL session conforming to `APIURLSessionProtocol`.
    init(apiURLSession: APIURLSessionProtocol) {
       self.apiURLSession = apiURLSession
    }
    
    /// Creates and logs an `APIError` with the given message.
    /// - Parameter message: The error message to log.
    /// - Returns: An `APIError` containing the message.
    private func dispachError(_ message: String) -> APIError {
        PLMLogger.logIt(message)
        return APIError.info(message)
    }
    
    /// Constructs a URL by appending a given path to the base URL.
    /// - Parameter path: The path to append.
    /// - Returns: A valid `URL` instance.
    /// - Throws: An error if URL construction fails.
    private func url(withPath path: String) throws -> URL {
        guard let url = URL(string: completeURL(with: path)) else {
            throw dispachError("Error in \(#function): failed to parse URL.")
        }
        return url
    }
    
    /// Completes the URL string by incorporating base URL, port, and any base URL interceptor.
    /// - Parameter path: The path to append.
    /// - Returns: The fully qualified URL string.
    private func completeURL(with path: String) -> String {
        if let baseURLInterceptor = baseURLInterceptor {
            guard let port = baseURLInterceptor.port else {
                return "\(baseURLInterceptor.baseURL)/\(path)"
            }
            return "\(baseURLInterceptor.baseURL):\(port)/\(path)"
        }
        
        if let port = port {
            return "\(baseURL):\(port)/\(path)"
        }
        
        return "\(baseURL)/\(path)"
    }
    
    /// Creates and configures a `URLRequest` asynchronously using given parameters.
    /// - Parameter nsParameters: The parameters describing the request.
    /// - Returns: A fully configured `URLRequest`.
    /// - Throws: An error if URL creation, encoding, or configuration fails.
    private func makeURLRequest(nsParameters: Parameters) async throws -> URLRequest {
        
        // Build path, optionally appending path parameter
        var path = nsParameters.path.rawValue
        if let param = nsParameters.param {
            path = "\(path)/\(param)"
        }
        
        // Construct URL
        let url = try self.url(withPath: path)
        
        // Prepare URLComponents for adding query parameters if any
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        if !nsParameters.queryString.isEmpty {
            let queryString = nsParameters.queryString
            urlComponents?.queryItems = queryString.map({ URLQueryItem(name: $0.rawValue, value: "\($1)") })
        }
        
        guard let urlWithComponents = urlComponents?.url else {
            throw dispachError("Error in \(#function): failed to create URL.")
        }
        
        var urlRequest = URLRequest(url: urlWithComponents)
        
        // Add API key header if available
        if let apiKey = apiKey {
            urlRequest.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        }
        
        // Allow interceptor to modify the request
        interceptor?.intercept(with: &urlRequest)
        
        // Set HTTP method
        urlRequest.httpMethod = nsParameters.method.rawValue
       
        // For non-GET requests, encode the request body if present
        if nsParameters.method != .GET, let httpRequest = nsParameters.httpRequest {
            let encoder = JSONEncoder()
            let data = try encoder.encode(httpRequest)
            urlRequest.httpBody = data
        }
        
        // Do not use cached responses
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        return urlRequest
    }
    
    /// Makes an asynchronous data request to the API.
    /// - Parameter nsParameters: Parameters defining the request.
    /// - Returns: A tuple containing the response data and URL response.
    /// - Throws: An error if the request fails.
    internal func make(nsParameters: Parameters) async throws -> (Data, URLResponse) {
        let urlRequest = try await makeURLRequest(nsParameters: nsParameters)
        return try await apiURLSession.session.data(for: urlRequest)
    }
    
    /// Makes an asynchronous download request to fetch a P12 certificate file.
    /// - Parameter nsParameters: Parameters defining the request.
    /// - Returns: A tuple containing the file URL of the downloaded certificate and the URL response.
    /// - Throws: An error if the download fails.
    internal func makeDownloadP12Certificate(nsParameters: Parameters) async throws -> (URL, URLResponse) {
        let urlRequest = try await makeURLRequest(nsParameters: nsParameters)
        return try await apiURLSession.session.download(for: urlRequest)
    }
    
    deinit {
        print("N_S DEINIT \(Self.self)")
    }
}
