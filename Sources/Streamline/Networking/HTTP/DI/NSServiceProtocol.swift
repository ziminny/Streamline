//
//  NSServiceProtocol.swift
//  AppAuth
//
//  Created by vagner reis on 01/10/24.
//

import Foundation

public protocol NSServiceProtocol where Self: Sendable {
    var factory: NSHTTPServiceFactoryProtocol { get }
    init(withFactory factory: NSHTTPServiceFactoryProtocol)
}
