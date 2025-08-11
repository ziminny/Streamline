//
//  File.swift
//  
//
//  Created by Vagner Oliveira on 03/07/23.
//

import Foundation

/// Protocolo utilizado para interceptar e personalizar a base URL na NSAPI.
public protocol NSCustomBaseURLInterceptor: AnyObject where Self: Sendable {
    
    /// A base URL a ser utilizada nas requisições.
    var baseURL: String { get set }
    
    /// A porta a ser utilizada na base URL, se aplicável.
    var port: Int? { get set }
}

public extension NSCustomBaseURLInterceptor {
    
    /// Valor padrão para a porta, caso não seja fornecida explicitamente.
    var port: Int? { nil }
}
