//
//  EnUS.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 30/08/24.
//

import Foundation

/// Struct representing the English (US) language implementation conforming to `InjectableLanguage`.
struct EnUS: InjectableLanguage {
    
    /// The language identifier for English (US).
    var language: Language { .enUS }
    
    /// Returns the translated message for the given translation request.
    ///
    /// - Parameter translateMessage: The translation message request.
    /// - Returns: The localized string in English (US).
    func fabricate(translateMessage: TranslateMessages) -> String {
        return translateMessage.message(with: language)
    }
}

