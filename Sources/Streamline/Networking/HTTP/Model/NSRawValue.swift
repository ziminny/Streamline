//
//  NSPath.swift
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

public protocol NSRawValue where Self: Sendable {
    var rawValue: String { get }
}
