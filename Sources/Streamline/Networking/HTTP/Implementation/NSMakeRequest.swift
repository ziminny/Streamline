//
//  NSMakeRequest.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 06/02/24.
//

import Foundation

final internal class NSMakeRequest {
     
    /// Configuração global da API.
    internal var configuration: NSAPIConfiguration { NSAPIConfiguration.shared }

    /// Porta para conexão à API (pode ser nula).
    private var port: Int? { configuration.port }

    /// URL base para as requisições à API.
    private var baseURL: String { configuration.baseUrl }

    /// Chave de API para autenticação (pode ser nula).
    private var apiKey: String? { configuration.apiKey }
    
    internal var apiURLSession: NSAPIURLSessionProtocol
    
    internal weak var interceptor: NSRequestInterceptor?
    
    internal weak var baseURLInterceptor: NSCustomBaseURLInterceptor?
    
    init(apiURLSession: NSAPIURLSessionProtocol) {
       self.apiURLSession = apiURLSession
        
    }
    
    /// Gera um erro `NSAPIError` com uma mensagem e a registra no log.
    /// - Parameter message: A mensagem de erro.
    /// - Returns: Um erro `NSAPIError` contendo a mensagem fornecida.
    private func dispachError(_ message: String) -> NSAPIError {
        PLMLogger.logIt(message)
        return NSAPIError.info(message)
    }
    
    /// Constrói uma URL com base no caminho fornecido, usando a URL completa após a aplicação do método `completeURL(with:)`.
    /// - Parameter path: O caminho a ser anexado à URL.
    /// - Returns: A URL resultante.
    /// - Throws: Um erro se a URL não puder ser construída.
    private func url(withPath path: String) throws -> URL {
        // Tenta criar uma URL usando a string completa da URL após a aplicação do método `completeURL(with:)`
        guard let url = URL(string: completeURL(with: path)) else {
            throw dispachError("Erro em \(#function): falha ao fazer parse da URL.")
        }
        return url
    }
    
    /// Completa a URL com o caminho fornecido, levando em consideração qualquer interceptor de URL base configurado, porta e URL base.
    /// - Parameter path: O caminho a ser anexado à URL.
    /// - Returns: A string de URL completa.
    private func completeURL(with path: String) -> String {
        
        // Verifica se há um interceptor de URL base configurado
        if let baseURLInterceptor = baseURLInterceptor {
            
            // Se uma porta estiver presente no interceptor, use-a na URL
            guard let port = baseURLInterceptor.port else {
                return "\(baseURLInterceptor.baseURL)/\(path)"
            }
            return "\(baseURLInterceptor.baseURL):\(port)/\(path)"
        }
        
        // Se uma porta estiver presente na configuração, use-a na URL
        if let port = port {
            return "\(baseURL):\(port)/\(path)"
        }
        
        // Use a URL base da configuração e anexe o caminho
        return "\(baseURL)/\(path)"
    }
    
    /// Cria e envia uma solicitação assíncrona ao servidor usando os parâmetros fornecidos.
    /// - Parameter nsParameters: Os parâmetros da solicitação.
    /// - Returns: Corpo da request.
    /// - Throws: Um erro se a criação da URL, a configuração da solicitação ou a obtenção dos dados falharem.
    private func makeURLRequest(nsParameters: NSParameters) async throws -> URLRequest {
        
        // Monta o caminho da URL com base nos parâmetros fornecidos
        var path = nsParameters.path.rawValue
        
        if let param = nsParameters.param {
            path = "\(path)/\(param)"
        }
        
        // Cria a URL completa
        let url = try self.url(withPath: path)
        
        // Configura os componentes da URL, incluindo a consulta (query string) se houver
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if !nsParameters.queryString.isEmpty {
            let queryString = nsParameters.queryString
            urlComponents?.queryItems = queryString.map({ URLQueryItem(name: $0.rawValue, value: "\($1)") })
        }
        
        // Verifica se os componentes da URL são válidos
        guard let urlWithComponents = urlComponents?.url else {
            throw dispachError("Erro em \(#function): falha ao criar a URL")
        }
        
        // Cria a solicitação URLRequest
        var urlRequest = URLRequest(url: urlWithComponents)
        
        // Adiciona a chave da API aos cabeçalhos da solicitação, se disponível
        if let apiKey = apiKey {
            urlRequest.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        }
        
        // Intercepta a solicitação, se um interceptor estiver configurado
        interceptor?.intercept(with: &urlRequest)
        
        // Configura o método HTTP da solicitação
        urlRequest.httpMethod = nsParameters.method.rawValue
       
        // Configura o corpo da solicitação para métodos diferentes de GET
        if nsParameters.method != .GET {
            if let httpRequest = nsParameters.httpRequest {
                let encoder = JSONEncoder()
                let data = try encoder.encode(httpRequest)                
                urlRequest.httpBody = data
            }
        }
        
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        
        return urlRequest
    }
    
    /// Cria e envia uma solicitação assíncrona ao servidor usando os parâmetros fornecidos.
    /// - Parameter nsParameters: Os parâmetros da solicitação.
    /// - Returns: Uma tupla contendo os dados da resposta e a resposta do servidor.
    /// - Throws: Um erro se a criação da URL, a configuração da solicitação ou a obtenção dos dados falharem.
    internal func make(nsParameters: NSParameters) async throws -> (Data, URLResponse) {
        
        let urlRequest = try await makeURLRequest(nsParameters: nsParameters)
        return try await apiURLSession.session.data(for: urlRequest)
        
    }
    
    internal func makeDownloadP12Certificate(nsParameters: NSParameters) async throws -> (URL, URLResponse) {
        
        let urlRequest = try await makeURLRequest(nsParameters: nsParameters)
        return try await apiURLSession.session.download(for: urlRequest)
        
    }
    
    deinit {
        print("N_S DEINIT \(Self.self)")
    }
    
}
