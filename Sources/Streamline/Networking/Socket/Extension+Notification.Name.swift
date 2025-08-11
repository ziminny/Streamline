//
//  Extension+Notification.Name.swift
//  AppAuth
//
//  Created by Vagner Oliveira on 07/02/24.
//

import Foundation

public extension Notification.Name {
    
    enum SocketEndpointsPasseiENEM: String, CaseIterable {
        case statisticsUser = "statisticsUser"
    }
    
    enum SocketEndpointsPasseiOAB: String, CaseIterable {
        case removeExpiredCompleteRoutine = "removeExpiredCompleteRoutine"
    }
    
    enum NSSocketProviderName: Hashable {
        case passeiOAB(SocketEndpointsPasseiOAB)
        case passeiENEM(SocketEndpointsPasseiENEM)
    }
    
    static func endpoint(_ endpoints: NSSocketProviderName) -> Notification.Name {
        switch endpoints {
        case .passeiOAB(let item):
            switch item {
            case .removeExpiredCompleteRoutine:
                return Notification.Name(item.rawValue)
            }
        case .passeiENEM(let item):
            switch item {
            case .statisticsUser:
                return Notification.Name(item.rawValue)
            }
        }
    }
    
}
