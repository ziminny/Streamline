//
//  PSKeychainProperties.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 26/10/24.
//

import Foundation

public extension PSKeychainCertificateHandler {
    
    /// Estrutura de propriedades para configuração e gerenciamento de informações de Keychain.
    /// Utilizada para armazenar propriedades relacionadas ao certificado e ao Keychain, como URL do certificado e senha do arquivo P12.
    struct PSKeychainProperties {
        
        /// Propriedade compartilhada e segura para acessar a instância de `PSKeychainProperties`.
        nonisolated(unsafe) public static var shared = PSKeychainProperties()
        
        /// Rótulo associado ao item salvo no Keychain. Utilizado para identificar a entrada do certificado no Keychain.
        public var keychainLabel: String = ""
        
        /// URL para o certificado P12. Deve apontar para o local do arquivo que será importado no Keychain.
        public var p12CertificateURL: URL?
        
        /// Senha para o certificado P12. Necessária para decodificar e importar o arquivo no Keychain.
        public var p12Password: String = ""
    }
    
}
