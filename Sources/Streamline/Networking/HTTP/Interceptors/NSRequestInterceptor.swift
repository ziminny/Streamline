//
//  NSInterceptor.swift
//
//  Created by Vagner Oliveira on 06/06/23.
//

import Foundation

/// Protocolo que define um interceptor de requisições.
public protocol NSRequestInterceptor: AnyObject where Self: Sendable {
    
    /// Intercepta o request.
    /// - Parâmetros:
    ///    - urlRequest: A referência do URLRequest a ser interceptado e possivelmente modificado.
    ///
    /// - Exemplo de Uso:
    ///     ```swift
    ///     intercept(with: &urlRequest)
    ///     ```
    func intercept(with urlRequest: inout URLRequest)
}

 
