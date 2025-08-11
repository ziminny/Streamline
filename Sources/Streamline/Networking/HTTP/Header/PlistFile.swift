//
//  PlistFile.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

/// Utilitário para decodificar valores a partir de arquivos plist.
internal class PListFile<Value:Codable> {
    
    /// Possíveis erros ao lidar com arquivos plist.
    ///
    /// - `fileNotFound`: Indica que o arquivo plist não foi encontrado.
    public enum PlistError: Error {
        case fileNotFound
    }
    
    internal enum Source {
        
        case infoPlist(_:Bundle)
        
        /// Obtém os dados do arquivo plist a partir da fonte.
        /// - Throws: PlistError.fileNotFound se o arquivo plist não for encontrado ou houver um problema ao obtê-lo.
        internal func data() throws -> Data {
            switch self {
            case .infoPlist(let bundle):
                guard let infoDict = bundle.infoDictionary else {
                    throw PlistError.fileNotFound
                }
                return try JSONSerialization.data(withJSONObject: infoDict)
            }
        }
    }
    
    /// Os dados decodificados do arquivo plist.
    internal let data: Value
    
    /// Inicializa um objeto PListFile com a fonte padrão sendo o arquivo info.plist do bundle principal.
    /// - Parameters:
    ///   - file: A fonte para obter os dados do arquivo plist.
    /// - Throws: PlistError.fileNotFound se o arquivo plist não for encontrado ou houver um problema ao obtê-lo.
    internal init(_ file: PListFile.Source = .infoPlist(Bundle.main)) throws {
        let rawData = try file.data()
        let decoder = JSONDecoder()
        self.data = try decoder.decode(Value.self, from: rawData)
    }
    
}
