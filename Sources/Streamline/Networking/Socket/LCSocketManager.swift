//
//  LCSocketManager.swift
//  AppAuth
//
//  Created by Vagner Oliveira on 07/02/24.
//

import Foundation
import SocketIO

/// `LCSocketManager` is a class responsible for managing socket connections using Socket.IO.
public final class LCSocketManager: NSObject, Sendable {
    
    /// Shared singleton instance of `LCSocketManager`.
    public static let shared = LCSocketManager()
    
    nonisolated(unsafe) private var manager: SocketManager?
    nonisolated(unsafe) private var socket: SocketIOClient?
    
    nonisolated private let socketQueue = DispatchQueue(label: "com.passeiNetworking.socket")
    
    /// Configures the socket with the provided configuration.
    ///
    /// - Parameter configuration: The socket configuration.
    /// - Returns: Returns the configured instance of `LCSocketManager`, or `nil` if the URL is invalid.
    @discardableResult
    public func setConfiguration(_ configuration: SocketConfiguration) -> Self? {
        
        var completeURL: String = configuration.url
        
        if let port = configuration.port {
            completeURL = "\(configuration.url):\(port)"
        }
        
        guard let url = URL(string: completeURL) else {
            print("Error creating socket URL")
            return nil
        }
        
        socketQueue.sync(flags: .barrier) {
            manager = SocketManager(socketURL: url, config: [.log(true), .extraHeaders(["authorization": "Bearer \(configuration.token)"])])
            socket = manager?.defaultSocket
        }
        
        return self
    }
    
    override private init() {
        super.init()
    }
    
    /// Emits a message to the socket server.
    ///
    /// - Parameters:
    ///   - eventName: The socket event name.
    ///   - message: The message to send, must conform to `Encodable`.
    ///   - completion: A closure called upon completion with an optional error.
    public func emit<T: Encodable>(eventName: SocketEmit, withMessage message: T, completion: @escaping (Error?) -> Void) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(message)
            
            socketQueue.sync(flags: .barrier) {
                socket?.emit(eventName.rawValue, data) {
                    completion(nil)
                }
            }
        } catch {
            completion(error)
        }
    }
    
    /// Registers a listener for a socket event and calls the completion handler with received data.
    ///
    /// - Parameters:
    ///   - eventName: The socket event to listen for.
    ///   - completion: A closure called when data is received for the event.
    public func received(eventName: Notification.Name, completion: @Sendable @escaping (Any?) -> Void) {
        
        let event = eventName.rawValue
        
        socketQueue.async {
            self.socket?.on(event) { (data, _) in
                completion(data.first)
            }
        }
    }
    
    /// Registers multiple event listeners and posts notifications when events are received.
    ///
    /// - Parameter eventsName: An array of socket event names to listen for.
    /// - Returns: The `LCSocketManager` instance with listeners registered.
    @discardableResult
    public func receivedPublisher(eventsName: [Notification.Name]) -> Self {
        for name in eventsName {
            let event = name.rawValue
            received(eventName: name) { result in
                if let result {
                    NotificationCenter.default.post(name: Notification.Name(event), object: result)
                }
            }
        }
        return self
    }
    
    /// Connects to the socket server.
    ///
    /// - Returns: The connected instance of `LCSocketManager`.
    @discardableResult
    public func connect() -> Self {
        socketQueue.sync(flags: .barrier) {
            socket?.connect()
        }
        print("Connected to Socket!")
        return self
    }
    
    /// Disconnects from the socket server and clears the socket reference.
    public func disconnect() {
        socketQueue.sync(flags: .barrier) {
            socket?.disconnect()
        }
        socket = nil
        print("Disconnected from Socket!")
    }
}

