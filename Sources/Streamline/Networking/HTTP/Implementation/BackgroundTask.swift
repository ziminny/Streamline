//
//  BackgroundTask.swift
//  PasseiCircleAnimation
//
//  Created by Vagner Oliveira on 07/11/23.
//

//https://support.apple.com/en-us/HT210596

import Foundation

public extension URLSessionConfiguration {
    /// Configuration for long-running background tasks (No cellular data allowed).
    static var timeConsumingBackgroundTasksNo3GAccess: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeader.headerDict
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 600 // 10 minutes
        configuration.timeoutIntervalForResource = 1800 // 30 minutes
        configuration.allowsCellularAccess = false
        configuration.allowsExpensiveNetworkAccess = false // Disallow expensive network usage
        configuration.allowsConstrainedNetworkAccess = false // Disallow low data mode access
        return configuration
    }
}

public extension URLSessionConfiguration {
    /// Configuration for long-running background tasks (Cellular data allowed).
    static var timeConsumingBackgroundTasks: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeader.headerDict
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 600 // 10 minutes
        configuration.timeoutIntervalForResource = 1800 // 30 minutes
        configuration.allowsCellularAccess = true
        configuration.allowsExpensiveNetworkAccess = true // Allow expensive network usage
        configuration.allowsConstrainedNetworkAccess = true // Allow low data mode access
        return configuration
    }
}

public extension URLSessionConfiguration {
    /// Configuration for average-length background tasks (Cellular data allowed).
    static var averageBackgroundTasks: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeader.headerDict
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 300 // 5 minutes
        configuration.timeoutIntervalForResource = 900 // 15 minutes
        configuration.allowsCellularAccess = true
        configuration.allowsExpensiveNetworkAccess = true
        configuration.allowsConstrainedNetworkAccess = true
        return configuration
    }
}

public extension URLSessionConfiguration {
    /// Configuration for light background tasks (Cellular data allowed).
    static var lightBackgroundTasks: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeader.headerDict
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 120 // 2 minutes
        configuration.timeoutIntervalForResource = 600 // 10 minutes
        configuration.allowsCellularAccess = true
        configuration.allowsExpensiveNetworkAccess = true
        configuration.allowsConstrainedNetworkAccess = true
        return configuration
    }
}

public extension URLSessionConfiguration {
    /// Configuration for main tasks (e.g., login, account creation).
    static var noBackgroundTask: URLSessionConfiguration {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = HTTPHeader.headerDict
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        configuration.allowsExpensiveNetworkAccess = true
        configuration.allowsConstrainedNetworkAccess = true
        // No specific timeout set, uses system defaults (usually shorter)
        return configuration
    }
}

