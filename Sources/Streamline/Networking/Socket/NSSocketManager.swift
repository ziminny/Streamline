//
//  NSSocketManager.swift
//  AppAuth
//
//  Created by Vagner Oliveira on 07/02/24.
//

import Foundation
import SocketIO

/// NSSocketManager é uma classe para gerenciar conexões de socket usando Socket.IO.
public final class NSSocketManager: NSObject, Sendable {
    
    /// Uma instância compartilhada de NSSocketManager.
    public static let shared = NSSocketManager()
    
    nonisolated(unsafe) private var manager: SocketManager?
    nonisolated(unsafe) private var socket: SocketIOClient?
    
    nonisolated private let socketQueue = DispatchQueue(label: "com.passeiNetworking.socket")
    
    /// Configura as informações do socket.
    ///
    /// - Parameter configuration: A configuração do socket.
    /// - Returns: Retorna uma instância de NSSocketManager configurada.
    @discardableResult
    public func setConfiguration(_ configuration: NSSocketConfiguration) -> Self? {
        
        var completeURL: String = configuration.url
        
        if let port = configuration.port {
            completeURL = "\(configuration.url):\(port)"
        }
        
        guard let url = URL(string: completeURL) else {
            print("Erro ao pegar a url do socket")
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
    
    /// Envia uma mensagem para o servidor.
    ///
    /// - Parameters:
    ///   - eventName: O nome do evento.
    ///   - message: A mensagem a ser enviada (deve ser Encodable).
    ///   - completion: Uma closure chamada após a conclusão do envio.
    public func emit<T: Encodable>(eventName: NSSocketEmit, withMessage message: T, completion: @escaping (Error?) -> Void){
        
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
    
    /// Processa eventos recebidos do servidor.
    ///
    /// - Parameters:
    ///   - eventName: O nome do evento recebido.
    ///   - completion: Uma closure chamada quando um evento é recebido.
    private func enumResult(eventName: Notification.Name.NSSocketProviderName) -> String {
          
        switch eventName {
        case .passeiOAB(let result):
            return result.rawValue
        case .passeiENEM(let result):
            return result.rawValue
        }
    }
    
    /// Processa eventos recebidos do servidor.
    ///
    /// - Parameters:
    ///   - eventName: O nome do evento recebido.
    ///   - completion: Uma closure chamada quando um evento é recebido.

    public func received(eventName: Notification.Name.NSSocketProviderName, completion: @Sendable @escaping (Any?) -> Void)  {
        
        let enumResult = enumResult(eventName: eventName)
        
        socketQueue.async  {
            self.socket?.on(enumResult) { (data, act) in
                
                if let result = data.first  {
                    completion(result)
                } else {
                    completion(nil)
                }
                
            }
        }
        
    }
    
    /// Registra observadores para eventos especificados e publica notificações quando esses eventos são recebidos.
      ///
      /// - Parameter eventsName: Os nomes dos eventos a serem registrados.
      /// - Returns: Retorna uma instância de NSSocketManager com os observadores registrados.
      @discardableResult
    public func receivedPublisher(eventsName: [Notification.Name.NSSocketProviderName]) -> Self  {
      
        for name in eventsName {
            
            let enumResult = enumResult(eventName: name)
            
            received(eventName: name) { result in
                if let result {
                    NotificationCenter.default.post(name: Notification.Name(enumResult), object: result)
                }
            }
        }
        return self
    }
    
    /// Conecta ao servidor de socket.
    ///
    /// - Returns: Retorna uma instância de NSSocketManager conectada.
    @discardableResult
    public func connect() -> Self {
        socketQueue.sync(flags: .barrier) {
            socket?.connect()
        }
        print("Connected to Socket!")
        return self
    }
    
    /// Desconecta do servidor de socket.
    public func disconnect() {
        socketQueue.sync(flags: .barrier) {
            socket?.disconnect()
        }
        socket = nil
        print("Disconnected from Socket!")
    }
      
} 
