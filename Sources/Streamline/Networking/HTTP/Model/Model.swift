//
//  Model.swift
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// Protocol that all models must conform to.
///
/// This protocol enforces that a model is both encodable and decodable,
/// and supports concurrency safety by conforming to `Sendable`.
///
/// - Example:
///   ```swift
///   class MyModel: Model {
///       // Your model implementation here
///   }
///   ```
public protocol Model: Decodable, Encodable, Sendable { }

