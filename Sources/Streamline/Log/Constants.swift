//
//  Constants.swift
//
//
//  Created by Vagner Oliveira on 05/09/23.
//

import Foundation
#if targetEnvironment(simulator) || os(macOS)

enum PathError: LocalizedError {
    case splitError
    
    var errorDescription: String? {
        switch self {
        case .splitError:
            return "Não foi possivel pegar o diretório do usuário"
        }
    }
}

/// Contém constantes utilizadas no modulo Log.
struct Constants {
    
#if swift(>=6.0)
    /// Caminho base para arquivos de log.
    private static func homeDirectoryLogs() throws(PathError) ->  String {
        return try NSHomeDirectory()
            .split(separator: "/")
            .map { String($0) }
            .getSafeCurentUser()
    }
    
    /// Caminho completo para o arquivo de log de depuração.
    ///
    /// O caminho é construído usando o diretório temporário (`path`) e o nome do produto (`productName`).
    static internal func path() throws(PathError) ->  String {
        let homeDirectory = try homeDirectoryLogs()
        return "\(homeDirectory)\(productName).txt"
    }
    
#else
    /// Caminho base para arquivos de log.
    private static func homeDirectoryLogs() throws ->  String {
        return try NSHomeDirectory()
            .split(separator: "/")
            .map { String($0) }
            .getSafeCurentUser()
    }
    
    /// Caminho completo para o arquivo de log de depuração.
    ///
    /// O caminho é construído usando o diretório temporário (`path`) e o nome do produto (`productName`).
    static internal func path() throws ->  String {
        let homeDirectory = try homeDirectoryLogs()
        return "\(homeDirectory)\(productName).log"
    }
#endif
    
    /// Obtém o identificador de pacote da aplicação.
    ///
    /// - Returns: O identificador de pacote da aplicação, ou `nil` se não estiver disponível.
    static private func getBundleIdentifier() -> String? {
        let bundleIdentifier = Bundle.main.bundleIdentifier
        return bundleIdentifier
    }

    /// Obtém o nome do produto da aplicação, removendo espaços em branco.
    ///
    /// - Returns: O nome do produto da aplicação.
    static private var productName: String {
        let bundle = Bundle.main
        let info = bundle.infoDictionary
        let prodName = ((info?["CFBundleName"] as? String) ?? "passei_debug").replacingOccurrences(of: " ", with: "")
        return prodName
    }
}

fileprivate extension Array where Element == String {
    
#if swift(>=6.0)
    func getSafeCurentUser() throws(PathError) -> Element {
        if count > 0 && self[0].elementsEqual("Users") {
            return String(describing: "/Users/\(self[1])/Library/Logs/")
        }
        
        throw .splitError
    }
#else
    func getSafeCurentUser() throws -> Element {
        if count > 0 && self[0].elementsEqual("Users") {
            return String(describing: "/Users/\(self[1])/Library/Logs/")
        }
        
        throw PathError.splitError
    }
#endif
    
}

#endif
