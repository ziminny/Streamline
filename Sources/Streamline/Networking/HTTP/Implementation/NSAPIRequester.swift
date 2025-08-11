//
//  File.swift
//
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// Responsável por fazer as requisições na API
internal final class NSAPIRequester: Sendable {
    
    internal nonisolated let delegateQueue = DispatchQueue(label: "com.passeiNetworking.NSAPIRequester", attributes: .concurrent)
    
    private nonisolated let privateisCancelableLock = NSLock()
    
    internal nonisolated(unsafe) weak var delegate: NSAPIConfigurationSessionDelegate?
    
    private nonisolated(unsafe) var isCancelableRequestGetRefreshToken: Bool = false

    /// Interceptor para modificar as requisições.
    internal nonisolated(unsafe) var interceptor: NSRequestInterceptor?

    /// Autorização para as requisições à API.
    internal nonisolated(unsafe) var authorization: NSAuthorization?

    /// Interceptor para modificar a URL base das requisições.
    internal nonisolated(unsafe) var baseURLInterceptor: NSCustomBaseURLInterceptor?
    
    internal let apiURLSession: NSAPIURLSessionProtocol
    
    private var makeRequest: NSMakeRequest {
        
        let request = NSMakeRequest(
            apiURLSession: apiURLSession
        )
        
        return request.apiURLSession.privateQueue.sync {
            request.interceptor = interceptor
            request.baseURLInterceptor = baseURLInterceptor
            request.apiURLSession.delegate = self
            return request
        }
        
    }
    
    init(apiURLSession: NSAPIURLSessionProtocol) {
        self.apiURLSession = apiURLSession
    }
    
    /// Converte uma resposta `URLResponse` para um objeto `HTTPURLResponse`. Lança um erro se a conversão falhar.
    /// - Parameter urlResponse: A resposta da URL a ser convertida.
    /// - Returns: A resposta HTTP convertida.
    /// - Throws: Um erro se a conversão falhar.
    private func response(with urlResponse: URLResponse) throws -> HTTPURLResponse {
        // Tenta realizar a conversão da resposta da URL para um objeto `HTTPURLResponse`
        guard let response = urlResponse as? HTTPURLResponse else {
            throw dispachError("Erro em \(#function): falha na conversão da resposta da URL.")
        }
        return response
    }

    /// Gera um erro `NSAPIError` com uma mensagem e a registra no log.
    /// - Parameter message: A mensagem de erro.
    /// - Returns: Um erro `NSAPIError` contendo a mensagem fornecida.
    private func dispachError(_ message: String) -> NSAPIError {
        PLMLogger.logIt(message)
        return NSAPIError.info(message)
    }

    /// Executa uma solicitação assíncrona para buscar dados do servidor, usando os parâmetros fornecidos.
    /// - Parameters:
    ///   - httpResponse: O tipo de resposta esperado que será usado para decodificar os dados.
    ///   - nsParameters: Os parâmetros da solicitação.
    /// - Returns: O modelo decodificado da resposta do servidor.
    /// - Throws: Um erro se a solicitação ou a decodificação falharem.
    internal func fetch<T: NSModel>(
        witHTTPResponse httpResponse: T.Type,
        andNSParameters nsParameters: NSParameters
    ) async throws -> T {
        // Tenta realizar a solicitação usando os parâmetros fornecidos
        return try await self.send(witHTTPResponse: httpResponse, nsParameters: nsParameters)
    }
    
    internal func downloadP12CertificateIfNeeded(
        nsParameters: NSParameters
    ) async throws -> URL  {
        
            // Tenta realizar a solicitação usando os parâmetros fornecidos
            let (url, urlResponse) = try await self.makeRequest.makeDownloadP12Certificate(nsParameters: nsParameters)
            
            // Obtém a resposta convertida para `HTTPURLResponse`
            let response = try self.response(with: urlResponse)
            
            // Resposta de sucesso (códigos 2xx)
            if NSHTTPStatusCodes.successRange ~= response.statusCode {
                return url
            }
            
            throw NSAPIError.acknowledgedByAPI(.init(statusCode: response.statusCode , message: "Erro desconhecido"))
         
        
    }
    
    /// Envia uma solicitação assíncrona para o servidor e trata a resposta de acordo com o modelo de resposta esperado.
    /// - Parameters:
    ///   - httpResponse: O tipo de resposta esperado que será usado para decodificar os dados.
    ///   - nsParameters: Os parâmetros da solicitação.
    /// - Returns: O modelo decodificado da resposta do servidor.
    /// - Throws: Um erro se a solicitação, a decodificação ou o tratamento da resposta falharem.
    private func send<T: NSModel>(
        witHTTPResponse: T.Type,
        nsParameters: NSParameters
    ) async throws -> T {
        
        // Tenta realizar a solicitação usando os parâmetros fornecidos
        let (data, urlResponse) = try await self.makeRequest.make(nsParameters: nsParameters)
                
        // Obtém a resposta convertida para `HTTPURLResponse`
        let response = try self.response(with: urlResponse)
        
        // Resposta de sucesso (códigos 2xx)
        if NSHTTPStatusCodes.successRange ~= response.statusCode {
            let jsonDecoder = JSONDecoder()
            let result = try jsonDecoder.decode(T.self, from: data)
            return result
        }
        
        // Token de acesso expirado (código 401)
        if response.statusCode == NSHTTPStatusCodes.unauthorized {
            // Verifica se há um provedor de autorização configurado
            guard let authorization = authorization else {
                PLMLogger.logIt("Erro em \(#function): provedor de autorização não implementado.")
                throw self.dispachError("Provedor de autorização não implementado.")
            }
            
            // Verifica se a solicitação de atualização do token pode ser cancelada
            if !isCancelableRequestGetRefreshToken {
                // Realiza a solicitação de atualização do token
                return try await authorization.refreshToken(completion: { [unowned self] (nsModel, nsPrams) async throws in
                    return try await self.refreshToken(
                        witHTTPResponse: nsModel,
                        nsParameters: nsPrams,
                        lastCallReponse: witHTTPResponse,
                        lastNSParameters: nsParameters
                    )
                })
            }
        }
        
        // Erro interno do servidor (código 500)
        if response.statusCode == NSHTTPStatusCodes.internalServerError {
            PLMLogger.logIt("Erro no servidor em \(#function), código de status \(response.statusCode)")
            throw dispachError("Erro interno no servidor")
        }
        
        // Trata outros erros provenientes da API
        let resultError = try self.throwsApiError(response: response, data: data)
        throw NSAPIError.acknowledgedByAPI(resultError)
    }
    
    /// Renova o token de acesso e realiza novamente a última chamada à API usando os parâmetros fornecidos.
    /// - Parameters:
    ///   - witHTTPResponse: O tipo de resposta esperada para a última chamada à API.
    ///   - nsParameters: Os parâmetros para a última chamada à API.
    ///   - lastCallReponse: O tipo de resposta esperada para a última chamada à API antes do refreshToken.
    ///   - lastNSParameters: Os parâmetros para a última chamada à API antes do refreshToken.
    /// - Returns: O modelo representando a resposta da última chamada à API após a renovação do token.
    /// - Throws: Um erro se a renovação do token falhar ou se a última chamada à API resultar em um erro.
    private func refreshToken<T: NSModel, S: NSModel>(
        witHTTPResponse: T.Type,
        nsParameters: NSParameters,
        lastCallReponse: S.Type,
        lastNSParameters: NSParameters
    ) async throws -> S {
        
        // Indica que a solicitação de refreshToken pode ser cancelada
        isCancelableRequestGetRefreshToken = true
        
        // Faz a solicitação de refreshToken
        let (data, urlResponse) = try await self.makeRequest.make(nsParameters: nsParameters)
        
        // Obtém a resposta do servidor
        let response = try self.response(with: urlResponse)
        
        // Se a resposta for bem-sucedida (código 200 ou 201)
        if (response.statusCode == NSHTTPStatusCodes.ok || response.statusCode == NSHTTPStatusCodes.created) {
            // Salva os dados do novo token de acesso
            self.authorization?.save(withData: data)
            // Realiza novamente a última chamada à API
            return try await self.fetch(witHTTPResponse: lastCallReponse, andNSParameters: lastNSParameters)
        }
        
        // Se o servidor retornar um erro interno (código 500)
        if response.statusCode == NSHTTPStatusCodes.internalServerError {
            throw dispachError("Erro interno do servidor em \(#function), código de status \(response.statusCode)")
        }
        
        // Obtém o erro específico da API, se houver
        let resultError = try self.throwsApiError(response: response, data: data)
        
        // Lança um erro com base no erro específico da API
        throw NSAPIError.acknowledgedByAPI(resultError)
    }

    /// Gera um objeto `NSAcknowledgedByAPI` a partir da resposta e dados fornecidos pela API.
    /// - Parameters:
    ///   - response: A resposta HTTP da API.
    ///   - data: Os dados da resposta da API.
    /// - Returns: Um objeto `NSAcknowledgedByAPI` representando o erro retornado pela API.
    /// - Throws: Um erro se a decodificação dos dados falhar.
    private func throwsApiError(response: HTTPURLResponse, data: Data) throws -> NSAcknowledgedByAPI {
        // Imprime o código de status para debug
        // Registra o erro no log
        PLMLogger.logIt("Erro em \(#function), código de status \(response.statusCode)")
        
        // Decodifica os dados da resposta em um objeto NSAcknowledgedByAPI
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(NSAcknowledgedByAPI.self, from: data)
    }
    
    deinit {
        print("N_S DEINIT \(Self.self)")
    }

}

extension NSAPIRequester: NSURLSessionConnectivity  {
    
    var configurationSession: URLSessionConfiguration {
        delegateQueue.sync(flags: .barrier) {
            return delegate?.configurationSession ?? .noBackgroundTask
        }
    }
    
    func checkWaitingForConnectivity(withURL url: URL?) {
        delegateQueue.async {
            self.delegate?.checkWaitingForConnectivity(withURL: url)
        }
    }
    
}
