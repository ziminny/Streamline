//
//  APIURLSession.swift.swift
//  PasseiNetworking
//
//  Created by Humberto Rodrigues on 06/11/23.
//

import Foundation
import Network

/// Class that handles the URL session for the API.
public final class APIURLSession: NSObject, APIURLSessionProtocol {
    
    /// Shared singleton instance of `APIURLSession`.
    public static let shared: APIURLSession = APIURLSession()
    
    /// Optional certificate interceptor for custom handling of SSL challenges.
    public nonisolated(unsafe) var certificateInterceptor: PSURLSessionLoadCertificate?
    
    /// Delegate for connectivity communication.
    public nonisolated(unsafe) weak var delegate: URLSessionConnectivity?
    
    /// URL session used for API requests.
    public var session: URLSession {
        privateQueue.sync(flags: .barrier) {
            return URLSession(configuration: delegate?.configurationSession ?? .noBackgroundTask, delegate: self, delegateQueue: nil)
        }
    }
    
    /// Private queue for synchronizing access and delegate callbacks.
    public nonisolated let privateQueue = DispatchQueue(label: "com.APIURLSession.URLSessionConnectivity", qos: .background)
    
    public nonisolated(unsafe) var onMetric: ((NetworkMetric) -> Void)?
    
    /// Private initializer to enforce singleton pattern.
    override private init() {
        super.init()
    }
    
}

extension APIURLSession: URLSessionTaskDelegate, URLSessionDelegate {
    
    /// Called when a task is waiting for connectivity.
    /// - Parameters:
    ///   - session: The URL session.
    ///   - task: The URL session task that is waiting for connectivity.
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        privateQueue.async {
            self.delegate?.checkWaitingForConnectivity(withURL: task.response?.url)
            
            // Cancel the task if the session configuration is not for background tasks.
            if let configuration = self.delegate?.configurationSession, configuration == .noBackgroundTask {
                task.cancel()
            }
        }
    }
    
    /// Handles authentication challenges from the server.
    /// - Parameters:
    ///   - session: The URL session.
    ///   - challenge: The authentication challenge.
    ///   - completionHandler: The completion handler to call with disposition and credential.
    public func urlSession(
        _ session: URLSession,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    ) {
        do {
            if let certificateInterceptor {
                try certificateInterceptor.urlSession(
                    session,
                    didReceive: challenge,
                    completionHandler: completionHandler
                )
                return
            }
            completionHandler(.performDefaultHandling, nil)
        } catch {
            // Handle error in processing challenge.
            print("Error handling challenge:", error)
            completionHandler(.performDefaultHandling, nil)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        NetworkFinishCollecting.shared.urlSession(
            session,
            task: task,
            didFinishCollecting: metrics,
            onMetric: onMetric
        )
    }
    
}

public extension URLSessionConnectivity {
    /// Default URL session configuration when not a background task.
    var configurationSession: URLSessionConfiguration { .noBackgroundTask }
}
