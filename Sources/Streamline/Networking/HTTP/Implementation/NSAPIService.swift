//
//  File.swift
//
//
//  Created by Vagner Oliveira on 02/06/23.
//

import Foundation
import Network
import Combine

/// Essa classe é exposta para o cliente
public final class NSAPIService: Sendable {
    
    /// Os parâmetros de uma solicitação de API.
    private nonisolated(unsafe) var nsParameters: NSParameters?
    
    private nonisolated let privateNSParametersInterceptorQueue = DispatchQueue(label: "com.passeiNetworking.NSAPIService.NSParameters", attributes: .concurrent)
    private nonisolated let privateInterceptorQueue = DispatchQueue(label: "com.passeiNetworking.NSAPIService.interceptor", attributes: .concurrent)
    private nonisolated let privateAuthorizationQueue = DispatchQueue(label: "com.passeiNetworking.NSAPIService.authorization", attributes: .concurrent)
    private nonisolated let privateBaseURLInterceptorQueue = DispatchQueue(label: "com.passeiNetworking.NSAPIService.baseURLInterceptor", attributes: .concurrent)
    private nonisolated let privateDelegateQueue = DispatchQueue(label: "com.passeiNetworking.NSAPIService.baseURLInterceptor", attributes: .concurrent)
    
    /// O objeto responsável por realizar as solicitações de API.
    private let apiRequester: NSAPIRequester
    
    /// Ao criar no módulo solicitado um NSAPIService, caso queira verificar a disponibilidade da internet, entregar a responsabilidade desse delegate
    private nonisolated(unsafe) weak var delegate: NSAPIServiceDelegate?
    
    public func setDeletage(delegate: NSAPIServiceDelegate) {
        privateDelegateQueue.async {
            self.delegate = delegate
        }
    }
    
    internal init(apiRequester: NSAPIRequester) {
        self.apiRequester = apiRequester
        apiRequester.delegateQueue.sync {
            apiRequester.delegate = self
        }
    }
    
    @discardableResult
    public func interceptor(_ interceptor: NSRequestInterceptor) -> Self {
        privateAuthorizationQueue.sync(flags: .barrier) {
            apiRequester.interceptor = interceptor
            return self
        }
    }
    
    @discardableResult
    public func certificate(keychain: PSKeychainCertificateProtocol = PSKeychainCertificateHandler()) -> Self {
        //#if DEVELOPMENT || RELEASE
        apiRequester.apiURLSession.certificateInterceptor = PSURLSessionLoadCertificate(keychain: keychain)
        //#endif
       
            return self
    }
    
    @discardableResult
    public func authorization(_ authorization: NSAuthorization) -> Self {
        privateInterceptorQueue.sync(flags: .barrier) {
            apiRequester.authorization = authorization
            return self
        }
    }
    
    @discardableResult
    public func customURL(_ nsCustomBaseURLInterceptor: NSCustomBaseURLInterceptor) -> Self {
        privateBaseURLInterceptorQueue.sync(flags: .barrier) {
            apiRequester.baseURLInterceptor = nsCustomBaseURLInterceptor
            return self
        }
    }
    
    /// Requisição de forma assincrona
    /// - Exemplo:
    ///     ```
    ///     func auth(request:OABAuthRequestModel) async throws  -> OABAuthResponseModel? {
    ///
    ///          let apiService = NSAPIService()
    ///
    ///          let nsParameters = NSParameters(
    ///          method: .POST,
    ///          httpRequest: request,
    ///          path: .passeiOAB(.auth)
    ///         )
    ///
    ///         let response = try await apiService.fetchAsync(OABAuthResponseModel.self, nsParameters: nsParameters)
    ///
    ///         return response
    ///
    ///     }
    ///     ```
    public func fetchAsync<T: NSModel>(_ httpResponse:T.Type, nsParameters: NSParameters) async throws -> T? {
        
        try await self.breakRequestIfNotBakgroundTask()
        
        return try await apiRequester.fetch(
            witHTTPResponse: httpResponse,
            andNSParameters: nsParameters
        )
    }
    
#if swift(<5.1)
    public func publisher<T: NSModel>(_ httpResponse: T.Type, nsParameters: NSParameters) -> Future<T?,Error> {
        
        return Future<T?,Error> { promise in
            Task {
                do {
                    
                    try await self.breakRequestIfNotBakgroundTask()
                    
                    let model = try await self.apiRequester.fetch(
                        witHTTPResponse: httpResponse,
                        andNSParameters: nsParameters
                    )
                    
                    promise(.success(model))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
#endif
    
    @discardableResult
    public func setNSParamns(withParameters nsParameters: NSParameters) -> Self {
        privateNSParametersInterceptorQueue.sync(flags: .barrier) {
            self.nsParameters = nsParameters
            return self
        }
    }
    
    
    /// Requisição com closure
    /// - Exemplo:
    ///     ```
    ///       func auth() {
    ///           // ...
    ///           // nsParameters
    ///           // ...
    ///           let apiService = NSAPIService()
    ///           apiService.fetch(MyModel.self) { result in
    ///               switch result {
    ///               case .success(let myModel):
    ///                   break;
    ///               case .failure(let error):
    ///                   break;
    ///               }
    ///          }
    ///      }
    ///     ```
    @discardableResult
    public func fetch<T: NSModel>(_ httpResponse: T.Type, closure: @Sendable @escaping (Result<T,Error>) -> Void ) -> Task<Void, Error> {
        
        Task { [weak self] in
            guard let self = self else { return }
            do {
                
                try await self.breakRequestIfNotBakgroundTask()
                
                guard let nsParameters = nsParameters else {
                    throw NSAPIError.unknownError()
                }
                
                let response = try await apiRequester.fetch(
                    witHTTPResponse: httpResponse,
                    andNSParameters: nsParameters
                )
                closure(.success(response))
            } catch {
                PLMLogger.logIt("error: \(#function) \(error.localizedDescription)")
                closure(.failure(error))
            }
            
        }
    }
    
    
    private func breakRequestIfNotBakgroundTask() async throws {
        try privateDelegateQueue.sync(flags: .barrier) {
            if self.delegate?.configurationSession == nil || self.delegate?.configurationSession == .noBackgroundTask {
                let service = NSNetworkStatus(queue: .global())
                if !service.isConnected {
                    throw NSAPIError.noInternetConnection
                }
            }
        }
    }
    
    public func downloadP12CertificateIfNeeded(
        nsParameters: NSParameters
    ) async throws -> URL {
        return try await apiRequester.downloadP12CertificateIfNeeded(nsParameters: nsParameters)
    }
    
    deinit {
        print("N_S DEINIT \(Self.self)")
    }
    
}

extension NSAPIService: NSAPIConfigurationSessionDelegate {
    func checkWaitingForConnectivity(withURL url: URL?) {
        delegate?.networkUnavailableAction(withURL: url)
    }
    
    var configurationSession: URLSessionConfiguration {
        delegate?.configurationSession ?? .noBackgroundTask
    }
}

