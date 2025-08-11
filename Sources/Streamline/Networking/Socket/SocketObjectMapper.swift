//
//  SocketObjectMapper.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 08/02/24.
//

import Foundation

/// Protocol defining a mapper that converts an array of dictionaries into a model representation.
public protocol SocketObjectMapper {
    
    /// The model type that the mapper produces.
    associatedtype Representation: Model
    
    /// Maps an array of dictionaries into a model representation.
    ///
    /// - Parameter arrayDictionary: An array of dictionaries representing the raw data.
    /// - Returns: An instance of the model representation created from the array.
    static func mapper(_ arrayDictionary: [[String: Any]]) -> Representation
}

