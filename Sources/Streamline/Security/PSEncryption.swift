//
//  PSEncryption.swift
//  PasseiHTTPCertificate
//
//  Created by Vagner Reis on 29/10/24.
//

import Foundation
import CryptoKit

/// `HCEncryption` é uma estrutura para realizar operações de criptografia e descriptografia usando AES-GCM.
/// Esta estrutura permite criptografar mensagens de texto e recuperar o texto original a partir de uma mensagem criptografada.
///
public struct PSEncryption {
    
    private let keyBase64: String
    
    /// Inicializa a instância `HCEncryption` com uma chave base64.
    ///
    /// - Parameter keyBase64: A chave de criptografia em formato base64.
    public init(keyBase64: String) {
        self.keyBase64 = keyBase64
    }
    
    /// Criptografa uma mensagem de texto usando AES-GCM.
    ///
    /// Este método converte a mensagem em dados, criptografa usando a chave simétrica e retorna
    /// uma `Data` combinada que inclui o IV, AuthTag e o texto criptografado.
    ///
    /// - Parameter message: A mensagem de texto a ser criptografada.
    /// - Returns: Os dados criptografados no formato `Data`.
    /// - Throws: Lança um erro se ocorrer algum problema ao codificar a chave, mensagem ou combinar os dados.
    public func encrypt(message: String) throws -> Data {
        // Gera um nonce aleatório
        let nonce = AES.GCM.Nonce()
        
        // Converte a chave para Data e cria o SymmetricKey
        guard let keyData = Data(base64Encoded: keyBase64) else {
            throw NSError(domain: "com.passei", code: 10, userInfo: ["error": "Erro ao decodificar a chave"])
        }
        let symmetricKey = SymmetricKey(data: keyData)
        
        // Converte a mensagem para Data
        guard let messageData = message.data(using: .utf8) else {
            throw NSError(domain: "com.passei", code: 10, userInfo: ["error": "erro no messageData"])
        }
        
        // Criptografa a mensagem
        let sealedBox = try AES.GCM.seal(messageData, using: symmetricKey, nonce: nonce)
        
        // Retorna os dados combinados (IV + Ciphertext + AuthTag)
        guard let combined = sealedBox.combined else  {
            throw NSError(domain: "com.passei", code: 10, userInfo: ["error": "erro ao tentar combinar os dados"])
        }
        
        return combined
    }
    
    /// Descriptografa uma mensagem criptografada usando AES-GCM.
    ///
    /// Este método separa o IV, Ciphertext e AuthTag dos dados criptografados,
    /// e usa a chave simétrica para recuperar o texto original.
    ///
    /// - Parameter encryptedMessage: A mensagem criptografada no formato `String` base64.
    /// - Returns: A mensagem de texto descriptografada.
    /// - Throws: Lança um erro se ocorrer algum problema ao decodificar a chave, nonce ou ao abrir os dados criptografados.
    public func decrypt(encryptedMessage: String) throws -> String {
        
        // Converte a mensagem criptografada de base64 para Data
        guard let encryptedMessageBase64 = Data(base64Encoded: encryptedMessage) else {
            throw NSError(domain: "com.passei", code: 10, userInfo: ["error": "encryptedMessageBase64"])
        }
        
        // Extrai o IV, Ciphertext e AuthTag dos dados
        let ivBase64 = encryptedMessageBase64[0..<12]
        let encryptedBase64 = encryptedMessageBase64[12..<(encryptedMessageBase64.count - 16)]
        let tag = encryptedMessageBase64[(encryptedMessageBase64.count - 16)...]
        
        // Converte a chave para Data e cria o SymmetricKey
        guard let keyData = Data(base64Encoded: keyBase64) else {
            throw NSError(domain: "com.passei", code: 10, userInfo: ["error": "Erro ao decodificar a chave"])
        }
        let symmetricKey = SymmetricKey(data: keyData)
        
        // Verifica o comprimento do IV
        guard ivBase64.count == 12 else {
            throw NSError(domain: "com.passei", code: 10, userInfo: ["error": "Erro ao decodificar ou IV inválido"])
        }
        
        // Cria o Nonce com o IV extraído
        let nonce = try AES.GCM.Nonce(data: ivBase64)
        
        // Cria o SealedBox com o nonce, ciphertext e AuthTag para descriptografar
        let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: encryptedBase64, tag: tag)
        let decryptedData = try AES.GCM.open(sealedBox, using: symmetricKey)
        
        // Converte os dados descriptografados para String
        guard let decryptedMessage = String(data: decryptedData, encoding: .utf8) else {
            throw NSError(domain: "com.passei", code: 10, userInfo: ["error": "decryptedMessage"])
        }
        
        return decryptedMessage
    }
}
