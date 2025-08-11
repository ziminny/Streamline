//
//  UserAgent.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation
#if os(iOS)
import UIKit
#endif

/// Estrutura para construir o cabeçalho User-Agent para requisições HTTP.
struct UserAgent: HTTPHeaderProtocol {
    
    /// Tipo de valor para o cabeçalho User-Agent.
    typealias ValueType = String
    
    /// Chave do cabeçalho User-Agent no contexto da configuração de cabeçalhos HTTP.
    static var headerKey: HTTPHeaderConfiguration.Keys { .userAgent }
    
    /// Valor do cabeçalho User-Agent, que depende do sistema operacional.
    
    static var headerValue: ValueType {
        
        #if os(iOS)
        
        // String para armazenar o valor do cabeçalho User-Agent
        var userAgentString: String = ""
        
        // Tenta obter informações do arquivo Info.plist
        if let infoPlist = try? PListFile<InfoPlist>(),
           let appName = infoPlist.data.bundleName,
           let version = infoPlist.data.versionNumber,
           let build = infoPlist.data.buildNumber,
           let cfNetworkVersionString = cfNetworkVersion {
            
            DispatchQueue.main.sync {
                // Obtém informações do dispositivo iOS
                let modelName = UIDevice.current.model
                let platform = UIDevice.current.systemName
                let operationSystemVersion = ProcessInfo.processInfo.operatingSystemVersionString
                
                // Constrói a string do cabeçalho User-Agent
                userAgentString = "\(appName)/\(version).\(build) " +
                    "(\(platform); \(modelName); \(operationSystemVersion)) " +
                    "CFNetwork/\(cfNetworkVersionString)"
            }
        }
        
        return userAgentString
        
        #else
        
        // Valor padrão para o caso de não ser iOS (pode ser ajustado para outras plataformas)
        return "MacOS"
        
        #endif
    }
    
    /// Obtém a versão do CFNetwork.
    static var cfNetworkVersion: String? {
        guard
            let bundle = Bundle(identifier: "com.apple.CFNetwork"),
            let versionAny = bundle.infoDictionary?[kCFBundleVersionKey as String],
            let version = versionAny as? String
        else { return nil }
        return version
    }
}
