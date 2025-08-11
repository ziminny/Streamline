//
//  MTLSKeychainConfiguration.swift
//  PasseiNetworking
//
//  Created by vagner reis on 25/10/24.
//

import Foundation

/// Configuration structure to manage mTLS (Mutual TLS) keychain operations.
public struct MTLSKeychainConfiguration {
    
    /// Internal facade responsible for keychain interactions.
    private var facade: PSKeychainFacade
    
    /// Initializes a new `MTLSKeychainConfiguration` instance.
    public init() {
        facade = PSKeychainFacade()
    }
    
    /// Sets the keychain label property.
    /// - Parameter keychainLabel: The label to identify the keychain item.
    public mutating func setProperties(keychainLabel: String) {
        PSKeychainCertificateHandler.PSKeychainProperties.shared.keychainLabel = keychainLabel
    }
    
    /// Sets the keychain label and P12 certificate URL properties.
    /// - Parameters:
    ///   - keychainLabel: The label to identify the keychain item.
    ///   - p12CertificateURL: Optional URL to the P12 certificate file.
    public mutating func setProperties(keychainLabel: String, p12CertificateURL: URL?) {
        PSKeychainCertificateHandler.PSKeychainProperties.shared.keychainLabel = keychainLabel
        PSKeychainCertificateHandler.PSKeychainProperties.shared.p12CertificateURL = p12CertificateURL
    }
    
    /// Sets the P12 certificate URL property.
    /// - Parameter p12CertificateURL: Optional URL to the P12 certificate file.
    public mutating func setProperties(p12CertificateURL: URL?) {
        PSKeychainCertificateHandler.PSKeychainProperties.shared.p12CertificateURL = p12CertificateURL
    }
    
    /// Sets keychain label, P12 certificate URL, and P12 certificate password properties.
    /// - Parameters:
    ///   - keychainLabel: The label to identify the keychain item.
    ///   - p12CertificateURL: Optional URL to the P12 certificate file.
    ///   - p12Password: The password for the P12 certificate.
    public mutating func setProperties(keychainLabel: String, p12CertificateURL: URL?, p12Password: String) {
        PSKeychainCertificateHandler.PSKeychainProperties.shared.keychainLabel = keychainLabel
        PSKeychainCertificateHandler.PSKeychainProperties.shared.p12CertificateURL = p12CertificateURL
        PSKeychainCertificateHandler.PSKeychainProperties.shared.p12Password = p12Password
    }
    
    /// Sets keychain label and P12 certificate password properties.
    /// - Parameters:
    ///   - keychainLabel: The label to identify the keychain item.
    ///   - p12Password: The password for the P12 certificate.
    public mutating func setProperties(keychainLabel: String, p12Password: String) {
        PSKeychainCertificateHandler.PSKeychainProperties.shared.keychainLabel = keychainLabel
        PSKeychainCertificateHandler.PSKeychainProperties.shared.p12Password = p12Password
    }
    
    /// Saves the client identity certificate to the keychain.
    /// - Throws: An error if saving fails.
    /// - Returns: `true` if the certificate was successfully saved.
    @discardableResult
    public mutating func saveIdentityToKeychain() throws -> Bool {
        try facade.saveCertificate()
    }
    
    /// Renews the client certificate in the keychain.
    /// - Throws: An error if renewal fails.
    public mutating func renewCertificate() throws {
        try facade.renewCertificate()
    }
    
    /// Removes the client identity certificate from the keychain.
    /// - Returns: `true` if the certificate was successfully removed.
    public mutating func removeIdentityFromKeychain() -> Bool {
        facade.removeCertificate()
    }
    
    /// Loads the client identity from the keychain.
    /// - Throws: An error if loading fails.
    /// - Returns: A `CFTypeRef` representing the client identity, or `nil` if none found.
    public mutating func loadClientIdentity() throws -> CFTypeRef? {
        try facade.loadCertificateIdentity()
    }
    
    /// Checks if a client identity exists in the keychain.
    /// - Returns: `true` if the identity exists; otherwise, `false`.
    public mutating func identityExistsInKeychain() -> Bool {
        facade.identityExistsInKeychain()
    }
    
    /// Saves a generic keychain model value.
    /// - Parameter value: The generic value conforming to `KeychainModel` protocol.
    /// - Throws: An error if saving fails.
    public mutating func saveGeneric<T: KeychainModel>(value: T) throws  {
        try facade.saveGeneric(value: value)
    }
    
    /// Loads a generic keychain model value of a specified type.
    /// - Parameter type: The type of the model to load.
    /// - Throws: An error if loading fails.
    /// - Returns: An optional loaded value of the specified type.
    public mutating func loadGeneric<T: KeychainModel>(ofType type: T.Type) throws -> T?  {
        try facade.loadGeneric(value: type)
    }
    
    /// Deletes a generic keychain model value of a specified type.
    /// - Parameter type: The type of the model to delete.
    /// - Throws: An error if deletion fails.
    public mutating func deleteGeneric<T: KeychainModel>(ofType type: T.Type) throws {
        try facade.deleteGeneric(value: type)
    }
    
}
