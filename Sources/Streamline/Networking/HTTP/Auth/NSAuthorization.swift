//
//  NSAuthorization.swift
//  
//
//  Created by Vagner Oliveira on 06/06/23.
//

import Foundation

/// Atutorização da API
public protocol NSAuthorization: AnyObject where Self: Sendable {
    
    /// Busca pelo refresh token e injeta da requisição
    ///  - NSModel.Type: Classe de retorno
    ///  - NSParameters: Parâmetros da requisição
    func refreshToken<T:NSModel>(completion: @escaping (NSModel.Type,NSParameters) async throws -> NSModel) async throws -> T
    
    func save(withData data:Data)
}
