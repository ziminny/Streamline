//
//  InfoPlist.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

/// Tipo para representar um esquema de URL.
internal typealias URLScheme = String

/// Estrutura que representa um tipo de URL, conforme especificado no arquivo Info.plist.
internal struct URLType: Codable {

    /// O papel desse tipo de URL.
    internal private(set) var role: String?
    
    /// O arquivo de ícone associado a esse tipo de URL.
    internal private(set) var iconFile: String?
    
    /// Os esquemas de URL associados a esse tipo de URL.
    internal private(set) var urlSchemes: [URLScheme]

    /// Chaves usadas durante a codificação e decodificação.
    private enum Key: String, CodingKey {
        case role = "CFBundleTypeRole"
        case iconFile = "CFBundleURLIconFile"
        case urlSchemes = "CFBundleURLSchemes"
    }

    /// Inicializador que realiza a decodificação a partir de um decoder.
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        role = try container.decodeIfPresent(String.self, forKey: .role)
        iconFile = try container.decodeIfPresent(String.self, forKey: .iconFile)
        urlSchemes = try container.decode([URLScheme].self, forKey: .urlSchemes)
    }
}

/// Estrutura que representa as informações do arquivo Info.plist.
internal struct InfoPlist: Codable {

    /// O nome a ser exibido para o aplicativo.
    internal private(set) var displayName: String?
    
    /// O identificador do pacote (bundle identifier) do aplicativo.
    internal private(set) var bundleId: String
    
    /// O nome do pacote do aplicativo.
    internal private(set) var bundleName: String?
    
    /// O número da versão do aplicativo.
    internal private(set) var versionNumber: String?
    
    /// O número da compilação do aplicativo.
    internal private(set) var buildNumber: String?

    /// Os tipos de URL especificados no arquivo Info.plist.
    internal private(set) var urlTypes: [URLType]?

    /// Chaves usadas durante a codificação e decodificação.
    private enum Key: String, CodingKey {
        case displayName = "CFBundleDisplayName"
        case bundleName = "CFBundleName"
        case bundleId = "CFBundleIdentifier"
        case versionNumber = "CFBundleShortVersionString"
        case buildNumber = "CFBundleVersion"
        case urlTypes = "CFBundleURLTypes"
    }

    /// Inicializador que realiza a decodificação a partir de um decoder.
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        bundleId = try container.decode(String.self, forKey: .bundleId)
        versionNumber = try container.decode(String.self, forKey: .versionNumber)
        buildNumber = try container.decode(String.self, forKey: .buildNumber)

        displayName = try? container.decodeIfPresent(String.self, forKey: .displayName)
        bundleName = try? container.decodeIfPresent(String.self, forKey: .bundleName)

        urlTypes = try? container.decodeIfPresent([URLType].self, forKey: .urlTypes)
    }
}
