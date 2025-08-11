//
//  PlistFile.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

/// Utility to decode values from plist files.
internal class PListFile<Value: Codable> {
    
    /// Possible errors when handling plist files.
    ///
    /// - `fileNotFound`: Indicates that the plist file was not found.
    public enum PlistError: Error {
        case fileNotFound
    }
    
    internal enum Source {
        
        case infoPlist(_: Bundle)
        
        /// Retrieves the data from the plist file based on the source.
        /// - Throws: PlistError.fileNotFound if the plist file is not found or there is an issue retrieving it.
        internal func data() throws -> Data {
            switch self {
            case .infoPlist(let bundle):
                guard let infoDict = bundle.infoDictionary else {
                    throw PlistError.fileNotFound
                }
                return try JSONSerialization.data(withJSONObject: infoDict)
            }
        }
    }
    
    /// The decoded data from the plist file.
    internal let data: Value
    
    /// Initializes a PListFile object with the default source being the info.plist file of the main bundle.
    /// - Parameters:
    ///   - file: The source to obtain the plist file data.
    /// - Throws: PlistError.fileNotFound if the plist file is not found or there is an issue retrieving it.
    internal init(_ file: PListFile.Source = .infoPlist(Bundle.main)) throws {
        let rawData = try file.data()
        let decoder = JSONDecoder()
        self.data = try decoder.decode(Value.self, from: rawData)
    }
    
}

