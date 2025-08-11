//
//  InjectableLanguage.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 30/08/24.
//

import Foundation

/// Protocol that defines a language injector capable of producing localized messages.
protocol InjectableLanguage {
    
    /// The language type used by the injector.
    associatedtype Language
    
    /// The language instance represented by the injector.
    var language: Language { get }
    
    /// Produces a localized string based on the provided translation message.
    ///
    /// - Parameter translateMessage: The translation message to be localized.
    /// - Returns: A localized string according to the language.
    func fabricate(translateMessage: TranslateMessages) -> String
}

