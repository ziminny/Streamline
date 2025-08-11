//
//  NSInjectableLanguage.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 30/08/24.
//

import Foundation

protocol NSInjectableLanguage {
    
    associatedtype Language where Language == NSLanguage
    
    var language: Language { get }
    
    func fabricate(translateMessage: NSTranslateMessages) -> String
}
