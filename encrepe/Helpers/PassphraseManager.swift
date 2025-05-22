import SwiftUI
import CryptoKit
import LocalAuthentication

class PassphraseManager: ObservableObject {
    @Published var isUnlocked = false
    @Published var showingPrompt = true
    @Published var errorMessage: String?
    @Published var isAppLocked = false
    @Published var isAuthenticating = false

    var encryptionKey: SymmetricKey?

    func submitPassphrase(_ passphrase: String) {
        if let existingSalt = KeyDerivation.loadSalt() {
            if let key = KeyDerivation.deriveKey(from: passphrase, salt: existingSalt),
               KeyDerivation.verifyKey(key) {
                encryptionKey = key
                isUnlocked = true
                showingPrompt = false
            } else {
                errorMessage = "Incorrect passphrase."
            }
        } else {
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

