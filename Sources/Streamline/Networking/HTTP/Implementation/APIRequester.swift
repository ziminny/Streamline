//
//  APIRequester.swift
//
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// Responsible for making API requests.
internal final class APIRequester: Sendable {
    
    /// Queue used for delegate synchronization.
    internal nonisolated let delegateQueue = DispatchQueue(label: "com.networking.APIRequester", attributes: .concurrent)
    
    private nonisolated let privateisCancelableLock = NSLock()
    
    /// Delegate to manage API session configuration.
    internal nonisolated(unsafe) weak var delegate: APIConfigurationSessionDelegate?
    
    /// Flag to indicate if refresh token requests can be canceled.
    private nonisolated(unsafe) var isCancelableRequestGetRefreshToken: Bool = false

    /// Interceptor used to modify requests.
    internal nonisolated(unsafe) var interceptor: RequestInterceptor?

    /// Authorization provider for API requests.
    internal nonisolated(unsafe) var authorization: Authorization?

    /// Interceptor to modify the base URL of requests.
    internal nonisolated(unsafe) var baseURLInterceptor: CustomBaseURLInterceptor?
    
    /// The URL session protocol used for network requests.
    internal let apiURLSession: APIURLSessionProtocol
    
    /// Factory to create `MakeRequest` instances configured with current interceptors and delegate.
    private var makeRequest: MakeRequest {
        let request = MakeRequest(apiURLSession: apiURLSession)
        return request.apiURLSession.privateQueue.sync {
            request.interceptor = interceptor
            request.baseURLInterceptor = baseURLInterceptor
            request.apiURLSession.delegate = self
            return request
        }
    }
    
    /// Initializes the APIRequester with a given URL session.
    /// - Parameter apiURLSession: The session protocol used for network operations.
    init(apiURLSession: APIURLSessionProtocol) {
        self.apiURLSession = apiURLSession
    }
    
    /// Converts a generic `URLResponse` to an `HTTPURLResponse`.
    /// - Parameter urlResponse: The URL response to convert.
    /// - Returns: The converted `HTTPURLResponse`.
    /// - Throws: Throws an error if conversion fails.
    private func response(with urlResponse: URLResponse) throws -> HTTPURLResponse {
        guard let response = urlResponse as? HTTPURLResponse else {
            throw dispachError("Error in \(#function): failed to convert URLResponse to HTTPURLResponse.")
        }
        return response
    }

    /// Creates and logs an `APIError` with a given message.
    /// - Parameter message: The error message.
    /// - Returns: An `APIError` instance containing the message.
    private func dispachError(_ message: String) -> APIError {
        PLMLogger.logIt(message)
        return APIError.info(message)
    }

    /// Performs an asynchronous fetch request to retrieve data from the server.
    /// - Parameters:
    ///   - witHTTPResponse: The expected response type to decode.
    ///   - nsParameters: The request parameters.
    /// - Returns: The decoded model from the server response.
    /// - Throws: Throws if the request or decoding fails.
    internal func fetch<T: Model>(
        witHTTPResponse httpResponse: T.Type,
        andParameters nsParameters: Parameters
    ) async throws -> T {
        return try await self.send(witHTTPResponse: httpResponse, nsParameters: nsParameters)
    }
    
    /// Downloads a P12 certificate if needed.
    /// - Parameter nsParameters: The parameters for the request.
    /// - Returns: URL of the downloaded P12 certificate.
    /// - Throws: Throws if the download fails or response is not successful.
    internal func downloadP12CertificateIfNeeded(
        nsParameters: Parameters,
        p12CertificateURLName: String
    ) async throws -> URL  {
        let (url, urlResponse) = try await self.makeRequest.makeDownloadP12Certificate(nsParameters: nsParameters)
        let response = try self.response(with: urlResponse)
        
        if HTTPStatusCodes.successRange ~= response.statusCode {
            if #available(iOS 17.0, *) {
                return url
            }
           return try urlcertificateMoveRollback(tempURL: url, p12CertificateURLName: p12CertificateURLName)
        }
        
        throw APIError.acknowledgedByAPI(.init(statusCode: response.statusCode, message: "Unknown error"))
    }
    
   
/// Moves a temporary file (e.g., from a download) into the app's Documents directory,
/// replacing any existing file with the same name.
///
/// - Parameters:
///   - tempURL: The temporary file URL (usually located in `/tmp`) returned by
///              operations such as `URLSessionDownloadTask`.
///   - p12CertificateURLName: The target file name to use in the Documents directory.
/// - Returns: The final destination URL inside the app's Documents directory.
/// - Throws: An error if the file cannot be moved or replaced.
private func urlcertificateMoveRollback(tempURL: URL, p12CertificateURLName: String) throws -> URL {
    let fileManager = FileManager.default
    let destinationURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent(p12CertificateURLName)

    // Remove the file if it already exists at the destination.
    if fileManager.fileExists(atPath: destinationURL.path) {
        try fileManager.removeItem(at: destinationURL)
    }

    // Move the temporary file to the destination.
    try fileManager.moveItem(at: tempURL, to: destinationURL)
    
    return destinationURL
}

    
    /// Sends an asynchronous request and handles the response according to the expected model type.
    /// - Parameters:
    ///   - witHTTPResponse: The expected response type to decode.
    ///   - nsParameters: The request parameters.
    /// - Returns: The decoded model from the server response.
    /// - Throws: Throws if the request, decoding, or response handling fails.
    private func send<T: Model>(
        witHTTPResponse: T.Type,
        nsParameters: Parameters
    ) async throws -> T {
        let (data, urlResponse) = try await self.makeRequest.make(nsParameters: nsParameters)
        let response = try self.response(with: urlResponse)
        
        if HTTPStatusCodes.successRange ~= response.statusCode {
            let jsonDecoder = JSONDecoder()
            let result = try jsonDecoder.decode(T.self, from: data)
            return result
        }
        
        if response.statusCode == HTTPStatusCodes.unauthorized || response.statusCode == HTTPStatusCodes.notAcceptable {
            guard let authorization = authorization else {
                PLMLogger.logIt("Error in \(#function): authorization provider not implemented.")
                throw self.dispachError("Authorization provider not implemented.")
            }
            
            let authorizationErrorCodes: AuthorizationErrorCodes
            
            if response.statusCode == HTTPStatusCodes.unauthorized {
                authorizationErrorCodes = .unauthorized
            } else {
                authorizationErrorCodes = .certificateError
            }
            
            if !isCancelableRequestGetRefreshToken {
                return try await authorization.refreshToken(statusCode: authorizationErrorCodes, completion: { [unowned self] (nsModel, nsParams) async throws in
                    return try await self.refreshToken(
                        witHTTPResponse: nsModel,
                        nsParameters: nsParams,
                        lastCallReponse: witHTTPResponse,
                        lastParameters: nsParameters
                    )
                })
            }
        }
        
        if response.statusCode == HTTPStatusCodes.internalServerError {
            PLMLogger.logIt("Server error in \(#function), status code \(response.statusCode)")
            throw dispachError("Internal server error")
        }
        
        let resultError = try self.throwsApiError(response: response, data: data)
        throw APIError.acknowledgedByAPI(resultError)
    }
    
    /// Refreshes the access token and retries the last API call with the given parameters.
    /// - Parameters:
    ///   - witHTTPResponse: Expected response type for the last API call.
    ///   - nsParameters: Parameters for the last API call.
    ///   - lastCallReponse: Response type for the last API call before token refresh.
    ///   - lastParameters: Parameters for the last API call before token refresh.
    /// - Returns: The model representing the response of the last API call after token refresh.
    /// - Throws: Throws if token refresh or the last API call fails.
    private func refreshToken<T: Model, S: Model>(
        witHTTPResponse: T.Type,
        nsParameters: Parameters,
        lastCallReponse: S.Type,
        lastParameters: Parameters
    ) async throws -> S {
        isCancelableRequestGetRefreshToken = true
        
        let (data, urlResponse) = try await self.makeRequest.make(nsParameters: nsParameters)
        let response = try self.response(with: urlResponse)
        
        if (response.statusCode == HTTPStatusCodes.ok || response.statusCode == HTTPStatusCodes.created) {
            self.authorization?.save(withData: data)
            return try await self.fetch(witHTTPResponse: lastCallReponse, andParameters: lastParameters)
        }
        
        if response.statusCode == HTTPStatusCodes.internalServerError {
            throw dispachError("Internal server error in \(#function), status code \(response.statusCode)")
        }
        
        let resultError = try self.throwsApiError(response: response, data: data)
        throw APIError.acknowledgedByAPI(resultError)
    }

    /// Parses an API error from the response and data returned by the server.
    /// - Parameters:
    ///   - response: The HTTP response from the API.
    ///   - data: The data returned by the API.
    /// - Returns: An `AcknowledgedByAPI` object representing the API error.
    /// - Throws: Throws if decoding the data fails.
    private func throwsApiError(response: HTTPURLResponse, data: Data) throws -> AcknowledgedByAPI {
        PLMLogger.logIt("Error in \(#function), status code \(response.statusCode)")
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(AcknowledgedByAPI.self, from: data)
    }
    
    deinit {
        debugPrint("N_S DEINIT \(Self.self)")
    }

}

extension APIRequester: URLSessionConnectivity  {
    
    /// Returns the URL session configuration provided by the delegate or a default no-background configuration.
    var configurationSession: URLSessionConfiguration {
        delegateQueue.sync(flags: .barrier) {
            return delegate?.configurationSession ?? .noBackgroundTask
        }
    }
    
    /// Requests the delegate to check for waiting connectivity for a given URL.
    /// - Parameter url: The URL to check connectivity for.
    func checkWaitingForConnectivity(withURL url: URL?) {
        delegateQueue.async {
            self.delegate?.checkWaitingForConnectivity(withURL: url)
        }
    }
    
}

