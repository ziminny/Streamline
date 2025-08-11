//
//  JWTDecoder.swift
//  
//
//  Created by Vagner Oliveira on 11/08/25.
//

import Foundation

/// Classe responsável por decodificar tokens JWT.
public class JWTDecoder {
    
    /// O token JWT a ser decodificado.
    private let jwt: String
    
    /// Inicializa a instância do decodificador com o token JWT fornecido.
    ///
    /// - Parameter jwt: O token JWT a ser decodificado.
    public init(withJwt jwt: String) {
        self.jwt = jwt
    }
     
    /// Decodifica o payload do token JWT para o tipo especificado.
    ///
    /// - Parameter ofType: O tipo do modelo para o qual o payload deve ser decodificado.
    /// - Returns: O modelo decodificado do tipo especificado.
    /// - Throws: Um erro do tipo `JWTError` se a decodificação falhar.
    ///
    /// - Note: Este método extrai o payload do token JWT, decodifica-o em um dicionário e em seguida tenta convertê-lo para o modelo especificado.
    public func decode<T: Decodable>(ofType: T.Type) throws -> T {
    
        let parts = self.jwt.components(separatedBy: ".")
        
        if parts.count != 3 {
            PLMLogger.logIt("Erro ao tentar decodificar o json em 3 partes")
            throw JWTError.partsError("Erro ao tentar decodificar o json em 3 partes")
        }
        
        let _ = parts[0] // header
        let payload = parts[1]
        let _ = parts[2] //signature
        
        // Erro ao tentar decodificar
        var dictionary = try? decodeJWTPart(payload: payload)
        
        if dictionary == nil {
            dictionary = try decodeJWTPart2(payload: payload)
        }
        
        guard let dictionary = dictionary else {
            PLMLogger.logIt("Erro ao tentar converte o dicionario em modelo")
            throw JWTError.notConvertData("Erro ao tentar converte o dicionario em modelo")
        }
        
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary)
        
        guard let payloadClass = try? JSONDecoder().decode(ofType, from: jsonData) else {
            PLMLogger.logIt("Erro ao tentar converte o dicionario em modelo")
            throw JWTError.notConvertData("Erro ao tentar converte o dicionario em modelo")
        }
        return payloadClass
    }
    
    /// Converte uma string base64 em outra string base64 com preenchimento correto.
    ///
    /// - Parameter encodedString: A string base64 a ser convertida.
    /// - Returns: A string base64 convertida com preenchimento correto.
    private func base64StringWithPadding(encodedString: String) -> String {
        var stringToEncode = encodedString.replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "_", with: "/")
  
        let paddingCount = encodedString.count % 4
        
        for _ in 0..<paddingCount {
            stringToEncode += "+"
        }
      
        return stringToEncode
    }
    
    /// Decodifica a parte do payload do token JWT e retorna o dicionário correspondente.
    ///
    /// - Parameter payload: A parte do payload do token JWT a ser decodificada.
    /// - Returns: O dicionário correspondente à parte do payload do token JWT.
    /// - Throws: Um erro do tipo `JWTError` se a decodificação falhar.
    private func decodeJWTPart(payload: String) throws -> [String: Any]? {
        // Remover espaços em branco no final da string
        let trimmedPayload = payload.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let payloadData = Data(base64Encoded: trimmedPayload) else {
            PLMLogger.logIt("Erro ao tentar converter para data")
            throw JWTError.notConvertData("Erro ao tentar converter para data")
        }

        guard let payloadDictionary = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] else {
            PLMLogger.logIt("Erro ao tentar converter para dicionário")
            throw JWTError.notConvertData("Erro ao tentar converter para dicionário")
        }

        return payloadDictionary
    }
    
    /// Decodifica a parte do payload do token JWT (variante 2) e retorna o dicionário correspondente.
    ///
    /// - Parameter payload: A parte do payload do token JWT a ser decodificada (variante 2).
    /// - Returns: O dicionário correspondente à parte do payload do token JWT (variante 2).
    /// - Throws: Um erro do tipo `JWTError` se a decodificação falhar.
    private func decodeJWTPart2(payload: String) throws -> [String: Any]? {
        // Remover espaços em branco no final da string
        let trimmedPayload = payload.trimmingCharacters(in: .whitespacesAndNewlines)

        // Calcular a quantidade de caracteres de preenchimento necessários para que a string base64 tenha um tamanho múltiplo de 4
        let paddingLength = 4 - (trimmedPayload.count % 4) % 4

        // Criar uma string com o payload e adicionar os sinais de igual necessários ao final
        let payloadPaddingString = trimmedPayload + String(repeating: "=", count: paddingLength)

        guard let payloadData = Data(base64Encoded: payloadPaddingString) else {
            PLMLogger.logIt("Erro ao tentar converter para data")
            throw JWTError.notConvertData("Erro ao tentar converter para data")
        }

        guard let payloadDictionary = try JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] else {
            PLMLogger.logIt("Erro ao tentar converter para dicionário")
            throw JWTError.notConvertData("Erro ao tentar converter para dicionário")
        }

        return payloadDictionary
    }
    
}
