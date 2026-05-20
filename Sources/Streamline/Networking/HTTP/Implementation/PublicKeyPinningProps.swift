//
//  PublicKeyPinningProps.swift
//  Streamline
//
//  Created by Vagner Reis on 20/05/26.
//

import Foundation

public struct PublicKeyPinningProps: Sendable {
    internal let validPins: [String]
    
    public init(validPins: [String]) {
        self.validPins = validPins
    }
}
