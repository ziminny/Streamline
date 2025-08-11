//
//  NSTranslate.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 30/08/24.
//

import Foundation

struct NSTranslate: Sendable {
    
    static let shared = NSTranslate()
    
    private func fabricate(translateMessage: NSTranslateMessages) -> String {
        let language = NSAPIConfiguration.shared.language
        
        let inject: any NSInjectableLanguage
        
        switch language {
        case .ptBR:
             inject = NSptBR()
        case .enUS:
             inject = NSenUS()
        }
        
        return inject.fabricate(translateMessage: translateMessage)
    }
    
    func message(_ translateMessage: NSTranslateMessages) -> String {
        return fabricate(translateMessage: translateMessage)
    }
    
}
