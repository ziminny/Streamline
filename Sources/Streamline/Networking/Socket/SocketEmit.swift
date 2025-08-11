//
//  SocketEmit.swift
//  AppAuth
//
//  Created by Vagner Oliveira on 07/02/24.
//

import Foundation

/// Enum representing the different types of socket emit events.
public enum SocketEmit {
    
    /// Event related to the PasseiOAB module.
    case passeiOAB(PasseiOAB)
    
    /// Events specific to PasseiOAB.
    public enum PasseiOAB: String {
        /// Event for updating user matters statistics.
        case userMattersStatisticsUpdate = "userMattersStatisticsUpdate"
    }
    
    /// The raw string value corresponding to the socket emit event.
    var rawValue: String {
        switch self {
        case .passeiOAB(let passeiOAB):
            return passeiOAB.rawValue
        }
    }
}
