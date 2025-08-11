//
//  NSModel.swift
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// Toda a model precisa imprementar essa classe
///  - Exemplo
///     ```
///            class MyModel:NSModel {
///            }
///      ```
public protocol NSModel: Decodable, Encodable, Sendable { }

