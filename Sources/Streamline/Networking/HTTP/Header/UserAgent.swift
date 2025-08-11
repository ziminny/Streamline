//
//  UserAgent.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation
#if os(iOS)
import UIKit
#endif

/// Structure to build the User-Agent header for HTTP requests.
struct UserAgent: HTTPHeaderProtocol {
    
    /// Value type for the User-Agent header.
    typealias ValueType = String
    
    /// Key of the User-Agent header in the context of HTTP header configuration.
    static var headerKey: HTTPHeaderConfiguration.Keys { .userAgent }
    
    /// Value of the User-Agent header, which depends on the operating system.
    static var headerValue: ValueType {
        
        #if os(iOS)
        
        // String to store the User-Agent header value
        var userAgentString: String = ""
        
        // Attempts to get information from the Info.plist file
        if let infoPlist = try? PListFile<InfoPlist>(),
           let appName = infoPlist.data.bundleName,
           let version = infoPlist.data.versionNumber,
           let build = infoPlist.data.buildNumber,
           let cfNetworkVersionString = cfNetworkVersion {
            
            DispatchQueue.main.sync {
                // Gets information about the iOS device
                let modelName = UIDevice.current.model
                let platform = UIDevice.current.systemName
                let operationSystemVersion = ProcessInfo.processInfo.operatingSystemVersionString
                
                // Builds the User-Agent header string
                userAgentString = "\(appName)/\(version).\(build) " +
                    "(\(platform); \(modelName); \(operationSystemVersion)) " +
                    "CFNetwork/\(cfNetworkVersionString)"
            }
        }
        
        return userAgentString
        
        #else
        
        // Default value for non-iOS platforms (can be adjusted for other platforms)
        return "MacOS"
        
        #endif
    }
    
    /// Retrieves the CFNetwork version.
    static var cfNetworkVersion: String? {
        guard
            let bundle = Bundle(identifier: "com.apple.CFNetwork"),
            let versionAny = bundle.infoDictionary?[kCFBundleVersionKey as String],
            let version = versionAny as? String
        else { return nil }
        return version
    }
}
