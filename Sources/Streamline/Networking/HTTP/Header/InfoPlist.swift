//
//  InfoPlist.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

/// Type alias representing a URL scheme.
internal typealias URLScheme = String

/// Structure representing a URL type as specified in the Info.plist file.
internal struct URLType: Codable {

    /// The role of this URL type.
    internal private(set) var role: String?
    
    /// The icon file associated with this URL type.
    internal private(set) var iconFile: String?
    
    /// The URL schemes associated with this URL type.
    internal private(set) var urlSchemes: [URLScheme]

    /// Keys used during encoding and decoding.
    private enum Key: String, CodingKey {
        case role = "CFBundleTypeRole"
        case iconFile = "CFBundleURLIconFile"
        case urlSchemes = "CFBundleURLSchemes"
    }

    /// Initializer that decodes from a decoder.
    internal init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Key.self)

        role = try container.decodeIfPresent(String.self, forKey: .role)
        iconFile = try container.decodeIfPresent(String.self, forKey: .iconFile)
        urlSchemes = try container.decode([URLScheme].self, forKey: .urlSchemes)
    }
}

/// Structure representing the information of the Info.plist file.
internal struct InfoPlist: Codable {

    /// The display name of the app.
    internal private(set) var displayName: String?
    
    /// The bundle identifier of the app.
    internal private(set) var bundleId: String
    
    /// The bundle name of the app.
    internal private(set) var bundleName: String?
    
    /// The version number of the app.
    internal private(set) var versionNumber: String?
    
    /// The build number of the app.
    internal private(set) var buildNumber: String?

    /// The URL types specified in the Info.plist file.
    internal private(set) var urlTypes: [URLType]?

    /// Keys used during encoding and decoding.
    private enum Key: String, CodingKey {
        case displayName = "CFBundleDisplayName"
        case bundleName = "CFBundleName"
        case bundleId = "CFBundleIdentifier"
        case versionNumber = "CFBundleShortVersionString"
        case buildNumber = "CFBundleVersion"
        case urlTypes = "CFBundleURLTypes"
    }

    /// Initializer that decodes from a decoder.
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
