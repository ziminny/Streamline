//
//  NetworkMetric.swift
//  Streamline
//
//  Created by Vagner Oliveira on 19/09/25.
//

import Foundation

/// Represents network request metrics collected from a URLSession task.
public struct NetworkMetric {
    /// The URL path of the request (e.g., "/posts").
    public let url: String
    
    /// The HTTP status code returned by the server (if available).
    public let statusCode: Int?
    
    /// Total duration of the request, in seconds.
    public let totalDuration: TimeInterval
    
    /// Duration spent performing DNS lookup, in seconds (if available).
    public let dnsDuration: TimeInterval?
    
    /// Duration spent in TLS handshake, in seconds (if available).
    public let tlsDuration: TimeInterval?
    
    /// Number of bytes sent in the request body.
    public let bytesSent: Int64
    
    /// Number of bytes received in the response body.
    public let bytesReceived: Int64
}

#if DEBUG
public extension NetworkMetric {
    /// Mock metrics for a "good" network scenario:
    /// - Fast Wi-Fi connection
    /// - Server nearby
    static var mockGood: Self {
        return NetworkMetric(
            url: "/posts",
            statusCode: 200,           // HTTP OK
            totalDuration: 0.25,       // 250 ms total
            dnsDuration: 0.015,        // 15 ms DNS lookup
            tlsDuration: 0.08,         // 80 ms TLS handshake
            bytesSent: 2_000,          // ~2 KB request body
            bytesReceived: 30_000      // ~30 KB response body
        )
    }

    /// Mock metrics for a "medium" network scenario:
    /// - Typical 4G connection
    /// - Server slightly farther
    static var mockMedium: Self {
        return NetworkMetric(
            url: "/posts",
            statusCode: 200,           // HTTP OK
            totalDuration: 0.75,       // 750 ms total
            dnsDuration: 0.045,        // 45 ms DNS lookup
            tlsDuration: 0.18,         // 180 ms TLS handshake
            bytesSent: 3_000,          // ~3 KB request body
            bytesReceived: 90_000      // ~90 KB response body
        )
    }

    /// Mock metrics for a "bad" network scenario:
    /// - Slow network or congested server
    static var mockBad: Self {
        return NetworkMetric(
            url: "/posts",
            statusCode: 500,           // Server error
            totalDuration: 2.5,        // 2.5 seconds total
            dnsDuration: 0.20,         // 200 ms DNS lookup
            tlsDuration: 0.40,         // 400 ms TLS handshake
            bytesSent: 4_000,          // ~4 KB request body
            bytesReceived: 250_000     // ~250 KB response body
        )
    }
}
#endif
