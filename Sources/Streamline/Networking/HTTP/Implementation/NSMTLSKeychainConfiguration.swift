//
//  NSMTLSKeychainConfiguration.swift
//  PasseiNetworking
//
//  Created by vagner reis on 25/10/24.
//

import Foundation

public struct NSMTLSKeychainConfiguration {
    
    private var facade: PSKeychainFacade
    
    public init() {
        facade = PSKeychainFacade()
    }
    
    public mutating func setProperties(keychainLabel: String) {
        PSKeychainCertificateHandler.PSKeychainProperties.shared.keychainLabel = keychainLabel
    }
    
    public mutating func setProperties(keychainLabel: String, p12CertificateURL: URL?) {
        PSKeychainCertificateHandler.PSKeychainProperties.shared.keychainLabel = keychainLabel
        PSKeychainCertificateHandler.PSKeychainProperties.shared.p12CertificateURL = p12CertificateURL
    }
    
    public mutating func setProperties(p12CertificateURL: URL?) {
        PSKeychainCertificateHandler.PSKeychainProperties.shared.p12CertificateURL = p12CertificateURL
    }
    
    public mutating func setProperties(keychainLabel: String, p12CertificateURL: URL?, p12Password: String) {
        PSKeychainCertificateHandler.PSKeychainProperties.shared.keychainLabel = keychainLabel
        PSKeychainCertificateHandler.PSKeychainProperties.shared.p12CertificateURL = p12CertificateURL
        PSKeychainCertificateHandler.PSKeychainProperties.shared.p12Password = p12Password
    }
    
    public mutating func setProperties(keychainLabel: String, p12Password: String) {
        PSKeychainCertificateHandler.PSKeychainProperties.shared.keychainLabel = keychainLabel
        PSKeychainCertificateHandler.PSKeychainProperties.shared.p12Password = p12Password
    }
    
    @discardableResult
    public mutating func saveIdentityToKeychain() throws -> Bool {
        try facade.saveCertificate()
    }
    
    public mutating func renewCertificate() throws {
        try facade.renewCertificate()
    }
    
    public mutating func removeIdentityFromKeychain() -> Bool {
        facade.removeCertificate()
    }
    
    public mutating func loadClientIdentity() throws -> CFTypeRef? {
        try facade.loadCertificateIdentity()
    }
    
    public mutating func identityExistsInKeychain() -> Bool {
        facade.identityExistsInKeychain()
    }
    
    public mutating func saveGeneric<T: KeychainModel>(value: T) throws  {
        try facade.saveGeneric(value: value)
    }
    
    
    public mutating func loadGeneric<T: KeychainModel>(ofType type: T.Type) throws -> T?  {
        try facade.loadGeneric(value: type)
    }
    
    public mutating func deleteGeneric<T: KeychainModel>(ofType type: T.Type) throws {
        try facade.deleteGeneric(value: type)
    }
    
}
