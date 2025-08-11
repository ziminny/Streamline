//
//  ServiceProtocol.swift
//  AppAuth
//
//  Created by vagner reis on 01/10/24.
//

import Foundation

public protocol ServiceProtocol where Self: Sendable {
    var factory: HTTPServiceFactoryProtocol { get }
    init(withFactory factory: HTTPServiceFactoryProtocol)
}
