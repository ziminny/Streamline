//
//  JWTError.swift
//  
//
//  Created by Vagner Oliveira on 10/06/23.
//

/// Erros relacionados à decodificação de tokens JWT.
public enum JWTError: Error {
    
    /// Indica um erro ao dividir as partes do token JWT.
    ///
    /// - Parameter String: Uma mensagem descritiva do erro.
    case partsError(String)
    
    /// Indica um erro ao tentar converter dados durante o processo de decodificação.
    ///
    /// - Parameter String: Uma mensagem descritiva do erro.
    case notConvertData(String)
}
