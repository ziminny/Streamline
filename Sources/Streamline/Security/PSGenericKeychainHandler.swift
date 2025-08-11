//
//  PSGenericKeychainHandler.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 26/10/24.
//

import Foundation
import Security

/// Protocolo que define as operações básicas para manipulação de dados genéricos no Keychain.
public protocol PSGenericKeychainProtocol {
    
    associatedtype T: KeychainModel
    
    /// Cria um novo item no Keychain.
    /// - Parameter value: O valor a ser salvo, conformando com o protocolo `KeychainModel`.
    /// - Throws: Lança um erro caso ocorra algum problema ao salvar o item.
    func create(value: T) throws
    
    /// Recupera um item do Keychain.
    /// - Returns: Uma instância do tipo `T` se os dados foram encontrados, `nil` caso contrário.
    /// - Throws: Lança um erro caso ocorra algum problema durante a recuperação dos dados.
    func get() throws -> T?
    
    /// Exclui um item do Keychain.
    /// - Throws: Lança um erro caso ocorra algum problema ao deletar o item.
    func delete() throws
}

/// Tipo base para o modelo de dados armazenado no Keychain, exigindo conformidade com `Decodable`, `Encodable` e `Sendable`.
public typealias KeychainModel = Decodable & Encodable & Sendable

/// Gerenciador de acesso ao Keychain para armazenamento seguro de dados genéricos.
/// Permite operações de criação, recuperação e exclusão de itens genéricos no Keychain.
public struct PSGenericKeychainHandler<T: KeychainModel>: PSGenericKeychainProtocol {
    
    /// Tag usada para identificar o item no Keychain.
    /// A tag é gerada automaticamente com base no tipo genérico para garantir unicidade.
    private let tag: Data
    
    /// Inicializador padrão que configura a tag usando o nome do tipo genérico.
    internal init() {
        self.tag = "\(T.self)".data(using: .utf8)!
    }
    
    /// Atualiza o item no Keychain com novos dados.
    /// - Parameter data: Os dados a serem atualizados no Keychain.
    /// - Returns: Um dicionário contendo a nova configuração de dados para atualização.
    /// - Throws: Lança um erro caso ocorra algum problema ao atualizar o item.
    private func update(data: Data) throws -> [CFString: Data] {
        let updatedItem = [kSecValueData: data]
        return updatedItem
    }
    
    /// Cria a query para adicionar um novo item no Keychain.
    /// - Parameter value: Os dados a serem salvos no Keychain.
    /// - Returns: Um dicionário com os parâmetros de configuração para salvar o item.
    private func createQuery(value: Data) -> [String: Any] {
        let addQuery: [String: Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): tag,
            String(kSecValueData): value
        ]
        return addQuery
    }
    
    /// Cria um novo item no Keychain.
    /// - Parameter value: O valor a ser salvo, que deve conformar com o protocolo `KeychainModel`.
    /// - Throws: Lança `PSGenericKeychainError.errorSaved` se ocorrer um erro ao salvar o item,
    /// ou `PSGenericKeychainError.errorUpdate` se houver falha na atualização.
    public func create(value: T) throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(value)
        let addQuery = self.createQuery(value: data)
        let updatedItem = try self.update(data: data)
        
        // Tenta adicionar o item no Keychain
        let status = SecItemAdd(addQuery as CFDictionary, nil)
        
        // Caso o item já exista, tenta atualizá-lo
        if status == errSecDuplicateItem {
            let result: OSStatus = SecItemUpdate(addQuery as CFDictionary, updatedItem as CFDictionary)
            guard result == errSecSuccess else { throw PSGenericKeychainError.errorUpdate(result) }
            return
        }
        
        guard status == errSecSuccess else { throw PSGenericKeychainError.errorSaved(status) }
    }
    
    /// Recupera um item do Keychain.
    /// - Returns: Uma instância decodificada do tipo `T` se os dados foram encontrados, `nil` caso contrário.
    /// - Throws: Lança `PSGenericKeychainError.errorGet` caso ocorra algum problema durante a recuperação dos dados.
    public func get() throws -> T? {
        let getQuery: [String: Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): tag,
            String(kSecReturnData): true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(getQuery as CFDictionary, &item)
        guard status == errSecSuccess else { throw PSGenericKeychainError.errorGet(status) }
        
        guard let keyData = item as? Data else { return nil }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(T.self, from: keyData)
        return result
    }
    
    /// Exclui um item do Keychain.
    /// - Throws: Lança `PSGenericKeychainError.errorDelete` se ocorrer um erro ao deletar o item.
    public func delete() throws {
        let deleteQuery: [String: Any] = [
            String(kSecClass): kSecClassKey,
            String(kSecAttrApplicationTag): tag
        ]
        
        let status = SecItemDelete(deleteQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw PSGenericKeychainError.errorDelete(status)
        }
    }
}
