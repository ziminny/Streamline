//
//  JWTTimeExpires.swift
//  
//
//  Created by Vagner Oliveira on 10/06/23.
//

import Foundation

/// Representa uma verificação de expiração de tempo para tokens JWT.
public class JWTTimeExpires {
    
    /// Indica se o token JWT associado expirou.
    @JWTCheck
    public var isExpired: Bool
    
    /// Inicializa uma instância de `JWTTimeExpires` com base no carimbo de tempo fornecido.
    ///
    /// - Parameter timestamp: O carimbo de tempo associado ao token JWT.
    public init(timestamp: TimeInterval) {
        self.isExpired = JWTCheck(timestamp: timestamp).wrappedValue
    }
}