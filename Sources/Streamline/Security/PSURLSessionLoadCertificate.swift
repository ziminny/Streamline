//
//  PSURLSessionLoadCertificate.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 17/10/24.
//

import Foundation

/// Estrutura responsável por carregar o certificado do Keychain e utilizá-lo em desafios de autenticação de `URLSession`.
public struct PSURLSessionLoadCertificate: Sendable {
    
    /// Instância do gerenciador de certificados `PSKeychainCertificateHandler`.
    private let keychain: PSKeychainCertificateProtocol
    
    /// Inicializa uma nova instância de `PSURLSessionLoadCertificate`.
    public init(keychain: PSKeychainCertificateProtocol) {
        self.keychain = keychain
    }
    
    /// Método para lidar com o desafio de autenticação do `URLSession`, fornecendo um certificado para autenticação do cliente.
    /// - Parameters:
    ///   - urlSession: Sessão de `URLSession` que recebe o desafio.
    ///   - challenge: O desafio de autenticação, que verifica o certificado do cliente.
    ///   - completionHandler: O manipulador de conclusão que determina a disposição do desafio e a credencial fornecida.
    /// - Throws: `PSError.itemNotFound` se o certificado não for encontrado no Keychain.
    public func urlSession(_: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) throws {
       
        // Verifica se o método de autenticação é de certificado de cliente.
        guard challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodClientCertificate else {
            completionHandler(.performDefaultHandling, nil)
            return
        }
        
        // Carrega a identidade (certificado) do Keychain
        guard let identity = try keychain.loadClientIdentity() else {
            throw PSCertificateError.itemNotFound
        }
        
        // Cria uma credencial com a identidade recuperada
        let credential = URLCredential(identity: identity as! SecIdentity, certificates: nil, persistence: .none)
        
        // Envia a credencial para o servidor
        challenge.sender?.use(credential, for: challenge)
        completionHandler(.useCredential, credential)
    }
}
