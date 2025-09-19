//
//  ApiPath.swift
//  NetworkMetric
//
//  Created by Vagner Oliveira on 19/09/25.
//

import Foundation
import Streamline

enum ApiPath {
    case defaultPath(Paths)
}

enum Paths: String, Sendable {
    case posts
}

extension ApiPath: RawValue {
    public var rawValue: String {
        switch self {
        case .defaultPath(let subcase):
            return subcase.rawValue
        }
    }
}
