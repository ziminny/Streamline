//
//  NetworkFinishCollecting.swift
//  Streamline
//
//  Created by Vagner Oliveira on 19/09/25.
//

import Foundation

/// A singleton class responsible for collecting URLSession task metrics
/// and transforming them into `NetworkMetric` objects for further processing.
internal class NetworkFinishCollecting {
    
    /// Shared singleton instance
    nonisolated(unsafe) internal static let shared = NetworkFinishCollecting()
    
    /// Private initializer to enforce singleton pattern
    private init() {}
    
    /// Processes metrics for a completed URLSession task
    /// - Parameters:
    ///   - session: The URLSession instance
    ///   - task: The completed URLSessionTask
    ///   - metrics: The collected URLSessionTaskMetrics
    ///   - onMetric: Optional closure called with the processed NetworkMetric
    func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didFinishCollecting metrics: URLSessionTaskMetrics,
        onMetric: ((NetworkMetric) -> Void)?
    ) {
        makeMetric(task: task, metrics: metrics, onMetric: onMetric)
    }
    
    /// Converts URLSessionTaskMetrics into a `NetworkMetric` object
    /// - Parameters:
    ///   - task: The URLSessionTask that finished
    ///   - metrics: Metrics collected for the task
    ///   - onMetric: Closure to call with the processed metric
    private func makeMetric(
        task: URLSessionTask,
        metrics: URLSessionTaskMetrics,
        onMetric: ((NetworkMetric) -> Void)?
    ) {
        // Ensure the task has an original URL
        guard let url = task.originalRequest?.url else { return }
        
        // Extract HTTP status code if available
        let statusCode = (task.response as? HTTPURLResponse)?.statusCode
         
        // Take the last transaction metrics (handles redirects)
        let t = metrics.transactionMetrics.last

        // Build a NetworkMetric object from the collected data
        let metric = NetworkMetric(
            url: url.path,
            statusCode: statusCode,
            totalDuration: metrics.taskInterval.duration,
            dnsDuration: duration(t?.domainLookupStartDate, t?.domainLookupEndDate),
            tlsDuration: duration(t?.secureConnectionStartDate, t?.secureConnectionEndDate),
            bytesSent: t?.countOfRequestBodyBytesSent ?? 0,
            bytesReceived: t?.countOfResponseBodyBytesReceived ?? 0
        )
        
        // Call the closure with the metric if provided
        onMetric?(metric)
    }
    
    /// Helper to calculate the duration between two dates
    /// - Parameters:
    ///   - start: Start date
    ///   - end: End date
    /// - Returns: Duration in seconds, or nil if start/end are nil
    private func duration(_ start: Date?, _ end: Date?) -> TimeInterval? {
        guard let s = start, let e = end else { return nil }
        return e.timeIntervalSince(s)
    }
    
}
