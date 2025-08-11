//
//  NSSocketEmit.swift
//  AppAuth
//
//  Created by Vagner Oliveira on 07/02/24.
//

import Foundation

public enum NSSocketEmit {
    
    case passeiOAB(PasseiOAB)
    
    public enum PasseiOAB: String {
        case userMattersStatisticsUpdate = "userMattersStatisticsUpdate"
    }
    
    var rawValue: String {
        switch self {
        case .passeiOAB(let passeiOAB):
            return passeiOAB.rawValue
        }
    }
}