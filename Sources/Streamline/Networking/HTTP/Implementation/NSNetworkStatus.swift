//
//  NSNetworkStatus.swift
//
//
//  Created by Vagner Oliveira on 02/06/23.
//

import Network
import Combine

public final class NSNetworkStatus: ObservableObject, @unchecked Sendable {

    @Published public var isConnected = true

    private let monitor: NWPathMonitor

    public init(queue: DispatchQueue = .main) {
        monitor = NWPathMonitor()

        monitor.pathUpdateHandler = { [weak self] path in
            Task { @MainActor in
                self?.isConnected = (path.status == .satisfied)
            }
        }

        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel() // <-- ESSENCIAL para evitar vazamento
    }
}

