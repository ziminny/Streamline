//
//  NSSocketConfiguration.swift
//  AppAuth
//
//  Created by Vagner Oliveira on 07/02/24.
//

import Foundation 

public class NSSocketConfiguration {
    
    internal let token: String
    internal let url: String
    internal let port: Int?
    
    public init(token: String, url: String, port: Int?) {
        self.token = token
        self.url = url
        self.port = port
    }
}