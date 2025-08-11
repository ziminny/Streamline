//
//  NSSocketObjectMapper.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 08/02/24.
//

import Foundation

public protocol NSSocketObjectMapper {
    
    associatedtype Representation: NSModel
    
    static func mapper(_ arrayDictionary: Array<[String:Any]>) -> Representation
    
}
