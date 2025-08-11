//
//  PSGenericKeychainError.swift
//  PasseiSecurity
//
//  Created by vagner reis on 31/10/24.
//

import Foundation

/// Enumeração que representa erros genéricos relacionados a operações de Keychain.
/// Cada caso contém o código de status (`OSStatus`) retornado pela operação de Keychain, fornecendo uma descrição detalhada do erro.
enum PSGenericKeychainError: LocalizedError {
    
    /// Erro ao tentar salvar um item no Keychain.
    case errorSaved(OSStatus)
    
    /// Erro ao tentar atualizar um item existente no Keychain.
    case errorUpdate(OSStatus)
    
    /// Erro ao tentar deletar um item do Keychain.
    case errorDelete(OSStatus)
    
    /// Erro ao tentar recuperar um item do Keychain.
    case errorGet(OSStatus)
    
    /// Descrição detalhada do erro, incluindo o código de status (`OSStatus`) retornado pela operação.
    /// A mensagem é automaticamente registrada pelo `PLMLogger`.
    var errorDescription: String? {
        
        let message: String
        
        defer {
            PLMLogger.logIt(message)
        }
        
        switch self {
            
        case .errorSaved(let status):
            message = "Erro ao tentar salvar o item no Keychain, status: \(status)"
        case .errorUpdate(let status):
            message = "Erro ao tentar atualizar o item do Keychain, status: \(status)"
        case .errorDelete(let status):
            message = "Erro ao tentar deletar o item do Keychain, status: \(status)"
        case .errorGet(let status):
            message = "Erro ao tentar recuperar o item do Keychain, status: \(status)"
        }
        
        return message
    }
}
