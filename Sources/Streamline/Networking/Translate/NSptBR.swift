//
//  NSptBR.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 30/08/24.
//

import Foundation

struct NSptBR: NSInjectableLanguage {
    
    typealias Language = NSLanguage
    
    var language: Language { .ptBR }
   
    func fabricate(translateMessage: NSTranslateMessages) -> String {
        return translateMessage.message(with: language)
    }
    
}
