

import Foundation
import SwiftUI
import LocalAuthentication

class AccountViewController: ObservableObject {
    @Published var revealCredentials = false
    @Published var unlocked = false
    @Published var text = "LOCKED"

    let account: Account

    init(account: Account) {
        self.account = account
    }

    func authenticateWithFaceID(completion: @escaping (Bool) -> Void) {
        authenticate { success in
            if success {
                completion(true)
            } else {
                // Handle authentication failure, if needed
                completion(false)
            }
        }
    }

    func authenticate(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                     error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: "Security") { success, authenticationError in

                if success {
                    self.text = "UNLOCKED"
                    completion(true)
                } else {
                    self.text = "There was a problem"
                    completion(false)
                }
            }
        } else {
            self.text = "Phone does not have biometrics"
            completion(false)
        }
    }

    func getCensoredText() -> String {
        return "********************"
    }
}


