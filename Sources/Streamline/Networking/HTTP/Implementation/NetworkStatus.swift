//
//  NetworkStatus.swift
//
//
//  Created by Vagner Oliveira on 02/06/23.
//

import Network
import Combine

import Network

/// Observable class that monitors the current network connectivity status.
public final class NetworkStatus: ObservableObject, @unchecked Sendable {
    
    /// Published property indicating whether the device is currently connected to a network.
    @Published public var isConnected = true
    
    /// Internal network path monitor instance.
    private let monitor: NWPathMonitor
    
    /// Initializes a new `NetworkStatus` instance and starts monitoring network changes.
    /// - Parameter queue: The dispatch queue on which network path updates will be delivered. Defaults to `.main`.
    public init(queue: DispatchQueue = .main) {
        monitor = NWPathMonitor()
        
        // Handler called when the network path changes.
        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                // Updates the published `isConnected` property on the main actor.
                self?.isConnected = (path.status == .satisfied)
            }
        }
        
        // Starts monitoring network changes on the specified queue.
        monitor.start(queue: queue)
    }
    
    deinit {
        // Stops monitoring when the instance is deallocated.
        monitor.cancel()
    }
}


