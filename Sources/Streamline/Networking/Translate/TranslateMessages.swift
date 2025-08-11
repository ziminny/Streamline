//
//  TranslateMessages.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 30/08/24.
//

import Foundation

/// Enum representing different translation messages.
enum TranslateMessages {
    case noInternetConnection
    case outher
    
    /// Returns the localized message string for the specified language.
    /// - Parameter lang: The language for the translation.
    /// - Returns: The localized message as a String.
    func message(with lang: Language) -> String {
        let messages: [Language: String]
        
        switch self {
        case .noInternetConnection:
            messages = [
                .enUS: "You are without an internet connection.",
                .ptBR: "Você está sem conexão com a internet."
            ]
            
        case .outher:
            messages = [
                .enUS: "",
                .ptBR: ""
            ]
        }
        
        // Fallback to English if no message found for the requested language
        return messages[lang] ?? messages[.enUS] ?? ""
    }
}

