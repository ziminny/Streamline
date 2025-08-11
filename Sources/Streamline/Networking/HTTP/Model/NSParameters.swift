//
//  NSParameters.swift
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// Classe carrega todos os parametros da requisição
///  - Attributes:
///    - method: O tipo do verbo http [  .GET .POST .DELETE .PUT  ]
///    - httpRequest: O tipo de resposta da requisição
///    - path: O path da requisição após a baseURL por exemplo a base url é htttp://minhautl.com.br/carros, neste caso o path seria carro
///    - queryString:  A queryString da requisição após o path por exemplo a base url é htttp://minhautl.com.br/carros?tipo=sedan, neste caso o path seria tipo=sedan
public struct NSParameters: @unchecked Sendable {
    
    public typealias Model = NSModel

    public let method: NSHTTPMethod
    public let httpRequest: Model?
    public let path: NSRawValue
    public let queryString: [ NSQueryString : Any ]
    public let param: Any?
    
    public init(
        method: NSHTTPMethod = .GET,
        httpRequest: Model? = nil,
        path: NSRawValue,
        queryString: [NSQueryString : Any] = [:],
        param: Any? = nil
    ) {
            
        self.method = method
        self.httpRequest = (method == .GET) ? nil : httpRequest
        self.path = path
        self.queryString = queryString
        self.param = param
            
    }
    
}
 
