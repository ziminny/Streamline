//
//  NSEncryption.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 29/10/24.
//

import Foundation

public struct NSEncryption {
    
    private let encryption: PSEncryption
    
    public init(keyBase64: String) {
        encryption = PSEncryption(keyBase64: keyBase64)
    }
    
    public func encrypt(message: String) throws -> Data {
        return try encryption.encrypt(message: message)
    }
    
    public func decrypt(encryptedMessage: String) throws -> String {
        return try encryption.decrypt(encryptedMessage: encryptedMessage)
    }
    
}
