//
//  EncryptionHelper.swift
//  encrepe
//
//  Created by Ian Pedeglorio on 2025-05-20.
//
import SwiftUI
import CryptoKit

class EncryptionHelper {
    static func encrypt(_ string: String, using key: SymmetricKey) -> Data? {
        guard let data = string.data(using: .utf8) else { return nil }
        do {
            let sealedBox = try AES.GCM.seal(data, using: key)
            return sealedBox.combined
        } catch {
            return nil
        }
    }

    static func decrypt(_ data: Data, using key: SymmetricKey) -> String? {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return String(data: decryptedData, encoding: .utf8)
        } catch {
            return nil
        }
    }
}

//let encrypted = EncryptionHelper.encrypt("mypassword", using: passphraseManager.encryptionKey!)
