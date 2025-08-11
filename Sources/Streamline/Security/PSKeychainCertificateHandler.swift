//
//  PSKeychainCertificateHandler.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 17/10/24.
//

import Foundation
import Security
import CoreFoundation

/// Protocolo que define as operações básicas para manipulação de certificados no Keychain.
public protocol PSKeychainCertificateProtocol where Self: Sendable {
    
    /// Salva uma identidade (certificado e chave privada) no Keychain.
    /// - Returns: `true` se a identidade foi salva com sucesso ou já existe no Keychain.
    /// - Throws: Lança um erro caso ocorra algum problema ao salvar a identidade.
    func saveIdentityToKeychain() throws -> Bool
    
    /// Renova o certificado no Keychain, removendo-o se existir e salvando-o novamente.
    /// - Throws: Lança um erro caso ocorra algum problema durante o processo de renovação.
    func renewCertificate() throws
    
    /// Remove uma identidade do Keychain.
    /// - Returns: `true` se a identidade foi removida com sucesso, `false` se não foi encontrada.
    func removeIdentityFromKeychain() -> Bool
    
    /// Carrega a identidade do cliente armazenada no Keychain.
    /// - Returns: Um objeto `CFTypeRef` que representa a identidade do cliente.
    /// - Throws: Lança um erro caso ocorra algum problema durante a recuperação da identidade.
    func loadClientIdentity() throws -> CFTypeRef?
    
    /// Verifica se uma identidade existe no Keychain.
    /// - Returns: `true` se a identidade existe no Keychain, `false` caso contrário.
    func identityExistsInKeychain() -> Bool
}

/// Estrutura responsável pelo gerenciamento de certificados no Keychain.
public struct PSKeychainCertificateHandler: PSKeychainCertificateProtocol {
    
    public init() { }
    
    /// Importa um certificado P12 do URL configurado nas propriedades.
    /// - Returns: Uma `SecIdentity` que representa a identidade (certificado e chave privada).
    /// - Throws: Lança um erro caso ocorra algum problema ao importar o certificado P12.
    private func importP12Certificate() throws -> SecIdentity {
        guard let p12CertificateURL = PSKeychainProperties.shared.p12CertificateURL else {
            throw PSCertificateError.urlError
        }
        
        guard let p12Data = try? Data(contentsOf: p12CertificateURL) else {
            throw PSCertificateError.dataError
        }
        
        let options: [String: Any] = [
            kSecImportExportPassphrase as String: PSKeychainProperties.shared.p12Password
        ]
        
        var items: CFArray?
        let securityError = SecPKCS12Import(p12Data as NSData, options as NSDictionary, &items)
        
        guard securityError == errSecSuccess else {
            throw PSCertificateError.importError
        }
        
        guard let item = (items as? [[String: Any]])?.first else {
            throw PSCertificateError.itemNotFound
        }
        
        let identity = item[kSecImportItemIdentity as String] as! SecIdentity
        return identity
    }
    
    /// Salva a identidade importada no Keychain.
    /// - Returns: `true` se a identidade foi salva com sucesso, `false` caso já exista.
    /// - Throws: Lança um erro caso ocorra algum problema ao salvar a identidade.
    @discardableResult
    public func saveIdentityToKeychain() throws -> Bool {
        let identity = try importP12Certificate()
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassIdentity,
            kSecAttrLabel as String: PSKeychainProperties.shared.keychainLabel,
            kSecValueRef as String: identity
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("Identidade salva com sucesso no Keychain")
            return true
        } else if status == errSecDuplicateItem {
            print("Item já existe no Keychain")
            return true
        }
        
        throw PSCertificateError.errorIdentitySave(status)
    }
    
    /// Renova a identidade no Keychain removendo-a e salvando-a novamente.
    /// - Throws: Lança um erro caso ocorra algum problema durante a renovação.
    public func renewCertificate() throws {
        if removeIdentityFromKeychain() || !identityExistsInKeychain() {
            try saveIdentityToKeychain()
        }
    }
    
    /// Remove a identidade do Keychain.
    /// - Returns: `true` se a identidade foi removida com sucesso, `false` se não foi encontrada ou ocorreu algum erro.
    public func removeIdentityFromKeychain() -> Bool {
        let deleteQuery: [String: Any] = [
            kSecClass as String: kSecClassIdentity,
            kSecAttrLabel as String: PSKeychainProperties.shared.keychainLabel
        ]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        
        if status == errSecSuccess {
            print("Item removido com sucesso.")
            return true
        } else if status == errSecItemNotFound {
            print("Item não encontrado no Keychain.")
            return false
        } else {
            print("Erro ao tentar remover item: \(status)")
            return false
        }
    }
    
    /// Carrega a identidade do cliente armazenada no Keychain.
    /// - Returns: Um objeto `CFTypeRef` que representa a identidade do cliente.
    /// - Throws: Lança um erro caso ocorra algum problema durante a recuperação da identidade.
    public func loadClientIdentity() throws -> CFTypeRef? {
        var identity: CFTypeRef?
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassIdentity,
            kSecAttrLabel as String: PSKeychainProperties.shared.keychainLabel,
            kSecReturnRef as String: true
        ]
        
        let status = SecItemCopyMatching(query as CFDictionary, &identity)
        if status == errSecSuccess {
            return identity
        }
        print("STATUS \(status)")
        throw PSCertificateError.errorLoadIdentity(status)
    }
    
    /// Verifica se a identidade existe no Keychain.
    /// - Returns: `true` se a identidade existe no Keychain, `false` caso contrário.
    public func identityExistsInKeychain() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassIdentity,
            kSecAttrLabel as String: PSKeychainProperties.shared.keychainLabel,
            kSecReturnRef as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        return status == errSecSuccess
    }

    /// Carrega todas as identidades armazenadas no Keychain.
    /// - Returns: Um `CFTypeRef` contendo todas as identidades encontradas.
    /// - Throws: Lança um erro caso ocorra algum problema durante a recuperação.
    func loadAll() throws -> CFTypeRef? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassIdentity,
            kSecReturnAttributes as String: true,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        var result: CFTypeRef?
        
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        if status != errSecSuccess {
            throw PSCertificateError.errorLoadIdentity(status)
        }
        
        return result
    }
}
