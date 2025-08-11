//
//  Translate.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 30/08/24.
//

import Foundation

/// A singleton responsible for providing localized translation messages.
struct Translate: Sendable {
    
    /// Shared singleton instance.
    static let shared = Translate()
    
    /// Internal method to generate a localized message based on current language setting.
    /// - Parameter translateMessage: The message container to translate.
    /// - Returns: The localized string.
    private func fabricate(translateMessage: TranslateMessages) -> String {
        let language = APIConfiguration.shared.language
        
        let inject: any InjectableLanguage
        
        switch language {
        case .ptBR:
            inject = PTBR()
        case .enUS:
            inject = EnUS()
        }
        
        return inject.fabricate(translateMessage: translateMessage)
    }
    
    /// Public method to get the localized message.
    /// - Parameter translateMessage: The message container to translate.
    /// - Returns: The localized string.
    func message(_ translateMessage: TranslateMessages) -> String {
        return fabricate(translateMessage: translateMessage)
    }
}

