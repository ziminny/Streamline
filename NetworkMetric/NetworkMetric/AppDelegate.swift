//
//  AppDelegate.swift
//  NetworkMetric
//
//  Created by Vagner Oliveira on 19/09/25.
//

import Foundation
import UIKit
import Streamline

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
        
        APIConfiguration.shared.application(
            "https://jsonplaceholder.typicode.com"
            )
        
        return true
    }
    
}
