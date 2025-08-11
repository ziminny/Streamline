//
//  JWTCheck.swift
//  
//
//  Created by Vagner Oliveira on 10/06/23.

import Foundation

/// Propriedade de embrulho que verifica a validade de um token JWT com base no timestamp de expiração.
///
/// - Note: Esta propriedade de embrulho pode ser utilizada para verificar a validade de um token JWT comparando o timestamp de expiração com a data atual. Se o timestamp de expiração for anterior à data atual, a propriedade será `false`; caso contrário, será `true`.
@propertyWrapper
public class JWTCheck {
    /// O valor interno que armazena o resultado da verificação da validade do token JWT.
    private var value: Bool
    
    /// O valor da propriedade de embrulho.
    public var wrappedValue: Bool {
        get { value }
        set { value = newValue }
    }
    
    /// Inicializa a propriedade de embrulho com um valor específico.
    ///
    /// - Parameter wrappedValue: O valor inicial da propriedade de embrulho.
    public init(wrappedValue: Bool) {
        self.value = wrappedValue
    }
    
    /// Inicializa a propriedade de embrulho com base no timestamp de expiração do token JWT.
    ///
    /// - Parameter timestamp: O timestamp de expiração do token JWT.
    ///
    /// - Note: Este inicializador calcula automaticamente se o token JWT é válido comparando o timestamp de expiração com a data atual.
    public init(timestamp: TimeInterval) {
        let currentDate = Date()
        let expirationDate = Date(timeIntervalSince1970: timestamp)
        self.value = currentDate > expirationDate
    }
}

