//
//  KeyDerivation.swift
//  encrepe
//
//  Created by Ian Pedeglorio on 2025-05-20.
//
import CryptoKit
import Foundation
import CommonCrypto

class KeyDerivation {
    static let saltKey = "encryptionSalt"
    static let validationKey = "encryptionValidationHash"

    static func generateSalt() -> Data {
        var salt = Data(count: 16)
        _ = salt.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, 16, $0.baseAddress!) }
        return salt
    }

    static func deriveKey(from passphrase: String, salt: Data) -> SymmetricKey? {
        let keyLength = 32
        var derivedKeyData = Data(count: keyLength)
        let passData = passphrase.data(using: .utf8)!

        let result = derivedKeyData.withUnsafeMutableBytes { derivedBytes in
            salt.withUnsafeBytes { saltBytes in
                passData.withUnsafeBytes { passBytes in
                    CCKeyDerivationPBKDF(CCPBKDFAlgorithm(kCCPBKDF2),
                                         passBytes.bindMemory(to: Int8.self).baseAddress!,
                                         passData.count,
                                         saltBytes.bindMemory(to: UInt8.self).baseAddress!,
                                         salt.count,
                                         CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                                         100_000,
                                         derivedBytes.bindMemory(to: UInt8.self).baseAddress!,
                                         keyLength)
                }
            }
        }

        return result == kCCSuccess ? SymmetricKey(data: derivedKeyData) : nil
    }


    static func saveValidation(for key: SymmetricKey, salt: Data) {
        let hash = SHA256.hash(data: key.withUnsafeBytes { Data($0) })
        UserDefaults.standard.set(Data(hash), forKey: validationKey)
        UserDefaults.standard.set(salt, forKey: saltKey)
    }

    static func verifyKey(_ key: SymmetricKey) -> Bool {
        guard let storedHash = UserDefaults.standard.data(forKey: validationKey) else { return false }
        let hash = SHA256.hash(data: key.withUnsafeBytes { Data($0) })
        return Data(hash) == storedHash
    }

    static func loadSalt() -> Data? {
        UserDefaults.standard.data(forKey: saltKey)
    }
}

