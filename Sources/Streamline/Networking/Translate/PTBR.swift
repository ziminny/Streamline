//
//  PTBR.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 30/08/24.
//

import Foundation

/// Implementation of `InjectableLanguage` for Brazilian Portuguese (pt-BR).
struct PTBR: InjectableLanguage {
    
    /// The language represented by this struct.
    var language: Language { .ptBR }
   
    /// Fabricates a translated message for Brazilian Portuguese.
    /// - Parameter translateMessage: The message container to translate.
    /// - Returns: The translated string in pt-BR.
    func fabricate(translateMessage: TranslateMessages) -> String {
        return translateMessage.message(with: language)
    }
}

