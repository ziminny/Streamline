//
//  PSKeychainFacade.swift
//  PasseiSecurity
//
//  Created by vagner reis on 31/10/24.
//

import Foundation

/// Uma fachada para o gerenciamento de certificados e dados genéricos no Keychain.
/// Oferece uma interface simplificada para operações comuns, como salvar, carregar e excluir dados,
/// aplicável tanto a certificados quanto a dados genéricos no Keychain.
public struct PSKeychainFacade {
    
    private var certificatehandler: PSKeychainCertificateProtocol?
    private var genericKeychain: (any PSGenericKeychainProtocol)?
    
    public init() {  }
    
    /// Salva um certificado (identidade) no Keychain.
    /// - Returns: `true` se a identidade foi salva com sucesso ou já existe no Keychain.
    /// - Throws: Lança um erro caso ocorra algum problema ao salvar a identidade.
    public mutating func saveCertificate() throws -> Bool {
        
        if certificatehandler == nil {
            certificatehandler = PSKeychainCertificateHandler()
        }
        
        return try certificatehandler?.saveIdentityToKeychain() ?? false
     }
    
    /// Renova o certificado no Keychain, removendo-o e salvando-o novamente.
    /// - Throws: Lança um erro caso ocorra algum problema durante o processo de renovação.
    public mutating func renewCertificate() throws {
        
        if certificatehandler == nil {
            certificatehandler = PSKeychainCertificateHandler()
        }
        
        try certificatehandler?.renewCertificate()
     }
    
    /// Carrega a identidade do cliente armazenada no Keychain.
    /// - Returns: Um objeto `CFTypeRef` que representa a identidade do cliente, ou `nil` se não encontrada.
    /// - Throws: Lança um erro caso ocorra algum problema durante a recuperação da identidade.
    public mutating func loadCertificateIdentity() throws -> CFTypeRef? {
        
        if certificatehandler == nil {
            certificatehandler = PSKeychainCertificateHandler()
        }
        
        return try certificatehandler?.loadClientIdentity()
    }
    
    /// Remove o certificado do Keychain.
    /// - Returns: `true` se a identidade foi removida com sucesso, `false` se não foi encontrada ou ocorreu algum erro.
    public mutating func removeCertificate() -> Bool {
        
        if certificatehandler == nil {
            certificatehandler = PSKeychainCertificateHandler()
        }
        
        return certificatehandler?.removeIdentityFromKeychain() ?? false
    }
    
    /// Verifica se uma identidade existe no Keychain.
    /// - Returns: `true` se a identidade existe no Keychain, `false` caso contrário.
    public mutating func identityExistsInKeychain() -> Bool {
        
        if certificatehandler == nil {
            certificatehandler = PSKeychainCertificateHandler()
        }
        
        return certificatehandler?.identityExistsInKeychain() ?? false
    }
    
    /// Salva dados genéricos no Keychain.
    /// - Parameter value: O valor genérico a ser salvo, conformando com o protocolo `KeychainModel`.
    /// - Throws: Lança um erro caso ocorra algum problema ao salvar o dado genérico.
    public mutating func saveGeneric<T: KeychainModel>(value: T) throws  {
        
        if genericKeychain == nil {
            genericKeychain = PSGenericKeychainHandler<T>()
        }
        
        guard let manager = genericKeychain as? PSGenericKeychainHandler<T> else {
            throw KeychainFacadeError.genericManagerNotConfigured
        }
        
        try manager.create(value: value)
    }
    
    /// Carrega dados genéricos do Keychain.
    /// - Parameter value: O tipo genérico dos dados a serem carregados, conformando com o protocolo `KeychainModel`.
    /// - Returns: Uma instância do tipo `T` se os dados foram encontrados, `nil` caso contrário.
    /// - Throws: Lança um erro caso ocorra algum problema durante a recuperação dos dados.
    public mutating func loadGeneric<T: KeychainModel>(value: T.Type) throws -> T?  {
        
        if genericKeychain == nil {
            genericKeychain = PSGenericKeychainHandler<T>()
        }
        
        guard let manager = genericKeychain as? PSGenericKeychainHandler<T> else {
            throw KeychainFacadeError.genericManagerNotConfigured
        }
        
        return try manager.get()
    }
    
    /// Exclui dados genéricos do Keychain.
    /// - Parameter value: O tipo dos dados a serem excluídos, conformando com o protocolo `KeychainModel`.
    /// - Throws: Lança um erro caso ocorra algum problema ao deletar os dados.
    public mutating func deleteGeneric<T: KeychainModel>(value: T.Type) throws {
        
        if genericKeychain == nil {
            genericKeychain = PSGenericKeychainHandler<T>()
        }
        
        guard let manager = genericKeychain as? PSGenericKeychainHandler<T> else {
            throw KeychainFacadeError.genericManagerNotConfigured
        }
        
        try manager.delete()
    }
}

/// Enum que define erros específicos para a `PSKeychainFacade`.
enum KeychainFacadeError: Error {
    /// Erro lançado quando o gerenciador genérico não foi configurado corretamente.
    case genericManagerNotConfigured
}
