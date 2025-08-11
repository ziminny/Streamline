//
//  NSenUS.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 30/08/24.
//

import Foundation

struct NSenUS: NSInjectableLanguage {

    typealias Language = NSLanguage
    
    var language: Language { .enUS }
    
    func fabricate(translateMessage: NSTranslateMessages) -> String {
        return translateMessage.message(with: language)
    }
    
}
