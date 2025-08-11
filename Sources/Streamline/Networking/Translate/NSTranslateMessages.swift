//
//  NSTranslateMessages.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 30/08/24.
//

import Foundation

enum NSTranslateMessages {
    case noInternetConnection
    case outher
    
    func message(with lang: NSLanguage) -> String {
        
        let message: [NSLanguage: String]
        
        switch self {
        case .noInternetConnection:
            message = [
                .enUS: "You are without an internet connection.",
                .ptBR: "Você está sem conexão com a internet."
            ]
            
            return message[lang]!
        case .outher:
            message = [
                .enUS: "",
                .ptBR: ""
            ]
            
            return message[lang]!
             
        }
    }
}
