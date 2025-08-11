//
//  PSCertificateError.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 17/10/24.
//

import Foundation

/// Enumeração de erros relacionados a operações de certificado, como manipulação de URLs, importação e operações de Keychain.
enum PSCertificateError: LocalizedError {
    
    /// Erro ao acessar ou processar a URL.
    case urlError
    
    /// Erro ao carregar ou manipular dados.
    case dataError
    
    /// Erro ao importar dados para o Keychain.
    case importError
    
    /// Erro indicando que o item não foi encontrado no Keychain.
    case itemNotFound
    
    /// Erro ao carregar a identidade do Keychain.
    /// Contém o código de status (`OSStatus`) retornado pela operação.
    case errorLoadIdentity(OSStatus) // Int32
    
    /// Erro ao salvar a identidade no Keychain.
    /// Contém o código de status (`OSStatus`) retornado pela operação.
    case errorIdentitySave(OSStatus) // Int32
    
    /// Descrição detalhada do erro para cada tipo de falha, registrada automaticamente no `PLMLogger`.
    var errorDescription: String? {
        
        let message: String
        
        defer {
            PLMLogger.logIt(message)
        }
        
        switch self {
        case .urlError:
            message = "Erro na URL"
        case .dataError:
            message = "Erro no carregamento de dados"
        case .importError:
            message = "Erro ao importar para o Keychain"
        case .itemNotFound:
            message = "Item não encontrado no Keychain"
        case .errorLoadIdentity(let status):
            message = "Erro ao carregar a identidade no Keychain, status: \(status)"
        case .errorIdentitySave(let status):
            message = "Erro ao salvar a identidade no Keychain, status: \(status)"
        }
        
        return message
    }
}
