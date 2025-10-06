//
//  APIService.swift
//
//
//  Created by Vagner Oliveira on 02/06/23.
//

import Foundation
import Network
import Combine

/// This class is exposed to the client for performing API requests.
public final class APIService: Sendable {
    
    /// The parameters of an API request.
    private nonisolated(unsafe) var nsParameters: Parameters?
    
    private nonisolated let privateParametersInterceptorQueue = DispatchQueue(label: "com.networking.APIService.Parameters", attributes: .concurrent)
    private nonisolated let privateInterceptorQueue = DispatchQueue(label: "com.networking.APIService.interceptor", attributes: .concurrent)
    private nonisolated let privateAuthorizationQueue = DispatchQueue(label: "com.networking.APIService.authorization", attributes: .concurrent)
    private nonisolated let privateBaseURLInterceptorQueue = DispatchQueue(label: "com.networking.APIService.baseURLInterceptor", attributes: .concurrent)
    private nonisolated let privateDelegateQueue = DispatchQueue(label: "com.networking.APIService.baseURLInterceptor", attributes: .concurrent)
    
    /// The object responsible for performing API requests.
    private let apiRequester: APIRequester
    
    /// If you want to check for internet availability when creating an `APIService`
    /// in the requested module, you can pass this delegate to handle connectivity.
    private nonisolated(unsafe) weak var delegate: APIServiceDelegate?
    
    public func setDeletage(delegate: APIServiceDelegate) {
        privateDelegateQueue.async {
            self.delegate = delegate
        }
    }
    
    internal init(apiRequester: APIRequester) {
        self.apiRequester = apiRequester
        apiRequester.delegateQueue.sync {
            apiRequester.delegate = self
        }
    }
    
    /// Sets a request interceptor.
    @discardableResult
    public func interceptor(_ interceptor: RequestInterceptor) -> Self {
        privateAuthorizationQueue.sync(flags: .barrier) {
            apiRequester.interceptor = interceptor
            return self
        }
    }
    
    /// Sets the certificate handler for secure communication.
    @discardableResult
    public func certificate(keychain: PSKeychainCertificateProtocol = PSKeychainCertificateHandler()) -> Self {
        //#if DEVELOPMENT || RELEASE
        apiRequester.apiURLSession.certificateInterceptor = PSURLSessionLoadCertificate(keychain: keychain)
        //#endif
        return self
    }
    
    /// Sets the authorization information for the request.
    @discardableResult
    public func authorization(_ authorization: Authorization) -> Self {
        privateInterceptorQueue.sync(flags: .barrier) {
            apiRequester.authorization = authorization
            return self
        }
    }
    
    /// Sets a custom base URL interceptor.
    @discardableResult
    public func customURL(_ nsCustomBaseURLInterceptor: CustomBaseURLInterceptor) -> Self {
        privateBaseURLInterceptorQueue.sync(flags: .barrier) {
            apiRequester.baseURLInterceptor = nsCustomBaseURLInterceptor
            return self
        }
    }
    
    /// Performs an asynchronous API request.
    ///
    /// **Example:**
    /// ```swift
    /// func auth(request: OABAuthRequestModel) async throws -> OABAuthResponseModel? {
    ///     let apiService = APIService()
    ///     let nsParameters = Parameters(
    ///         method: .POST,
    ///         httpRequest: request,
    ///         path: .passeiOAB(.auth)
    ///     )
    ///     let response = try await apiService.fetchAsync(OABAuthResponseModel.self, parameters: nsParameters)
    ///     return response
    /// }
    /// ```
    public func fetchAsync<T: Model>(_ httpResponse: T.Type, parameters: Parameters) async throws -> T? {
        try await self.breakRequestIfNotBakgroundTask()
        
        return try await apiRequester.fetch(
            witHTTPResponse: httpResponse,
            andParameters: parameters
        )
    }
    
#if swift(<5.1)
    /// Returns a Combine publisher for performing the request.
    public func publisher<T: Model>(_ httpResponse: T.Type, parameters: Parameters) -> Future<T?,Error> {
        return Future<T?,Error> { promise in
            Task {
                do {
                    try await self.breakRequestIfNotBakgroundTask()
                    
                    let model = try await self.apiRequester.fetch(
                        witHTTPResponse: httpResponse,
                        andParameters: parameters
                    )
                    
                    promise(.success(model))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
#endif
    
    /// Sets request parameters.
    @discardableResult
    public func setParamns(withParameters nsParameters: Parameters) -> Self {
        privateParametersInterceptorQueue.sync(flags: .barrier) {
            self.nsParameters = nsParameters
            return self
        }
    }
    
    /// Performs an API request using a completion handler.
    ///
    /// **Example:**
    /// ```swift
    /// func auth() {
    ///     // ...
    ///     let apiService = APIService()
    ///     apiService.fetch(MyModel.self) { result in
    ///         switch result {
    ///         case .success(let myModel):
    ///             // Handle success
    ///         case .failure(let error):
    ///             // Handle failure
    ///         }
    ///     }
    /// }
    /// ```
    @discardableResult
    public func fetch<T: Model>(_ httpResponse: T.Type, closure: @Sendable @escaping (Result<T,Error>) -> Void ) -> Task<Void, Error> {
        
        Task { [weak self] in
            guard let self = self else { return }
            do {
                try await self.breakRequestIfNotBakgroundTask()
                
                guard let nsParameters = nsParameters else {
                    throw APIError.unknownError()
                }
                
                let response = try await apiRequester.fetch(
                    witHTTPResponse: httpResponse,
                    andParameters: nsParameters
                )
                closure(.success(response))
            } catch {
                PLMLogger.logIt("error: \(#function) \(error.localizedDescription)")
                closure(.failure(error))
            }
        }
    }
    
    /// Verifies internet connection before executing the request,
    /// unless the session is configured for background tasks.
    private func breakRequestIfNotBakgroundTask() async throws {
        try privateDelegateQueue.sync(flags: .barrier) {
            if self.delegate?.configurationSession == nil || self.delegate?.configurationSession == .noBackgroundTask {
                let service = NetworkStatus(queue: .global())
                if !service.isConnected {
                    throw APIError.noInternetConnection
                }
            }
        }
    }
    
    deinit {
        print("N_S DEINIT \(Self.self)")
    }
}

extension APIService: APIConfigurationSessionDelegate {
    func checkWaitingForConnectivity(withURL url: URL?) {
        delegate?.networkUnavailableAction(withURL: url)
    }
    
    var configurationSession: URLSessionConfiguration {
        delegate?.configurationSession ?? .noBackgroundTask
    }
}
