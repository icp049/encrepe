//
//  PassphraseManager.swift
//  encrepe
//
//  Created by Ian Pedeglorio on 2025-05-20.
//

import SwiftUI
import CryptoKit

class PassphraseManager: ObservableObject {
    @Published var isUnlocked = false
    @Published var showingPrompt = true
    @Published var errorMessage: String?
    var encryptionKey: SymmetricKey?

    func submitPassphrase(_ passphrase: String) {
        if let existingSalt = KeyDerivation.loadSalt() {
            // Returning user
            if let key = KeyDerivation.deriveKey(from: passphrase, salt: existingSalt),
               KeyDerivation.verifyKey(key) {
                encryptionKey = key
                isUnlocked = true
                showingPrompt = false
            } else {
                errorMessage = "Incorrect passphrase."
            }
        } else {
            // First-time user
            let salt = KeyDerivation.generateSalt()
            if let key = KeyDerivation.deriveKey(from: passphrase, salt: salt) {
                KeyDerivation.saveValidation(for: key, salt: salt)
                encryptionKey = key
                isUnlocked = true
                showingPrompt = false
            }
        }
    }
}
