//
//  Encryption.swift
//  PasseiHTTPCertificate
//
//  Created by vagner reis on 29/10/24.
//

import Foundation

/// A structure responsible for handling encryption and decryption operations.
public struct Encryption {
    
    /// The underlying encryption handler.
    private let encryption: PSEncryption
    
    /// Initializes the `Encryption` instance with a base64-encoded key.
    /// - Parameter keyBase64: The encryption key encoded as a base64 string.
    public init(keyBase64: String) {
        encryption = PSEncryption(keyBase64: keyBase64)
    }
    
    /// Encrypts a plain text message.
    /// - Parameter message: The plain text message to encrypt.
    /// - Returns: The encrypted message as `Data`.
    /// - Throws: An error if encryption fails.
    public func encrypt(message: String) throws -> Data {
        return try encryption.encrypt(message: message)
    }
    
    /// Decrypts an encrypted message.
    /// - Parameter encryptedMessage: The encrypted message as a string.
    /// - Returns: The decrypted plain text message.
    /// - Throws: An error if decryption fails.
    public func decrypt(encryptedMessage: String) throws -> String {
        return try encryption.decrypt(encryptedMessage: encryptedMessage)
    }
    
}

