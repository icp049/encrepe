import SwiftUI

struct PassphrasePromptView: View {
    @ObservedObject var manager: PassphraseManager
    @State private var passphrase = ""
    @State private var repeatPassphrase = ""
    @FocusState private var focusedField: Field?
    @State private var keyboardPrimed = false

    enum Field {
        case passphrase, repeatPassphrase
    }

    var isFirstTime: Bool {
        KeyDerivation.loadSalt() == nil
    }

    var passphrasesMatch: Bool {
        !passphrase.isEmpty && passphrase == repeatPassphrase
    }

    var showMatchStatus: Bool {
        isFirstTime && !repeatPassphrase.isEmpty
    }

    var body: some View {
        ZStack {
            // Dismiss keyboard on background tap
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }

            VStack(spacing: 16) {
                if isFirstTime {
                    Text("🔐 Set a Secure Passphrase")
                        .font(.title3)
                        .bold()

                    Text("This passphrase is used to encrypt all your saved credentials. If you forget it, all data will be permanently inaccessible.")
                        .font(.footnote)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 10)
                } else {
                    Text("🔐 Enter Your Passphrase")
                        .font(.title3)
                        .bold()
                }

                SecureField("Passphrase", text: $passphrase)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)
                    .focused($focusedField, equals: .passphrase)

                if isFirstTime {
                    SecureField("Repeat Passphrase", text: $repeatPassphrase)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                        .focused($focusedField, equals: .repeatPassphrase)

                    if showMatchStatus {
                        Text(passphrasesMatch ? "✅ Passphrases match" : "❌ Passphrases do not match")
                            .font(.caption)
                            .foregroundColor(passphrasesMatch ? .green : .red)
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                if let error = manager.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                }

                Button("Continue") {
                    manager.submitPassphrase(passphrase)
                    passphrase = ""
                    repeatPassphrase = ""
                    focusedField = nil
                }
                .disabled(isFirstTime && !passphrasesMatch)
                .opacity(isFirstTime && !passphrasesMatch ? 0.4 : 1)
                .padding(.top)
            }
            .padding()
            .onAppear {
                if !keyboardPrimed {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        focusedField = .passphrase // 🔑 Focus input + show keyboard
                        keyboardPrimed = true
                    }
                }
            }
        }
    }
}

