//
//  RawValue.swift
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// A protocol that requires conforming types to provide a `rawValue` of type `String`.
///
/// This protocol is constrained to types that conform to `Sendable`.
public protocol RawValue where Self: Sendable {
    
    /// The string representation of the conforming type.
    var rawValue: String { get }
}

