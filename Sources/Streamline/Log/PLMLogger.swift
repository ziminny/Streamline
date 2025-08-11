//
//  PLMLogger.swift
//
//
//  Created by Vagner Oliveira on 05/09/23.
//

import Foundation
import OSLog

@available(iOS 13.4, *)
/// Gerencia o registro de logs da aplicação.
public struct PLMLogger {
    
    /// Registra uma mensagem no arquivo de log ou na console, dependendo do ambiente de execução.
    ///
    /// - Parameter message: A mensagem a ser registrada.
    public static func logIt(_ message: String, type: OSLogType = .info) {
        
#if targetEnvironment(simulator) || os(macOS)
        
        do {
            let filePath = try Constants.path()
                        
            let fileManager: FileManager = .default
            
            // Se estiver no simulador, registra a mensagem em um arquivo de log no diretório temporário.
            if !fileManager.fileExists(atPath: filePath) {
                if fileManager.createFile(atPath: filePath, contents: nil, attributes: [FileAttributeKey.posixPermissions: 0o644]) {
                    print("O arquivo de log foi criado no caminho \(filePath)")
                }
            }
            
            if let fileHandle = FileHandle(forWritingAtPath: filePath) {
                let message = "\n\(Date().timeIntervalSince1970): \(message)"
                if let data = message.data(using: .utf8) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            }
        } catch {
            print("Erro ao tentar salvar no path, descriçao: ", error.localizedDescription)
        }
        
#endif
        
        os_log("%@", log: .customCategory, type: type, message as CVarArg)

    }
}

/// Extensão para definir uma categoria personalizada para os logs.
fileprivate extension OSLog {
    
    /// Subsistema utilizado para os logs.
    private static let subsystem: String = Bundle.main.bundleIdentifier!
    
    /// Categoria personalizada para os logs.
    static let customCategory: OSLog = OSLog(subsystem: subsystem, category: "Passei-group")
}

