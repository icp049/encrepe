// AccountView.swift
import SwiftUI
import LocalAuthentication

struct AccountView: View {
    @State private var showingEditView = false
    @State private var revealCredentials = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var passphraseManager: PassphraseManager

    let account: Account

    @State private var decryptedUsername: String = ""
    @State private var decryptedPassword: String = ""

    @State private var showCopiedToast = false
    @State private var copiedLabelText = ""

    let bulletMask = "•••••••••••••••••••••"
    let sharedFont = Font.system(size: 14, design: .monospaced)

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 20) {
                credentialRow(icon: "🪪", value: decryptedUsername, masked: !revealCredentials) {
                    copyToClipboard(decryptedUsername, "Username copied!")
                }

                credentialRow(icon: "🔑", value: decryptedPassword, masked: !revealCredentials) {
                    copyToClipboard(decryptedPassword, "Password copied!")
                }

                if !revealCredentials {
                    Button("Decrypt") {
                        authenticateWithSystem { success in
                            if success, !passphraseManager.isAppLocked, let key = passphraseManager.encryptionKey {
                                decryptedUsername = EncryptionHelper.decrypt(account.username ?? Data(), using: key) ?? "Decryption error"
                                decryptedPassword = EncryptionHelper.decrypt(account.password ?? Data(), using: key) ?? "Decryption error"
                                withAnimation {
                                    revealCredentials = true
                                }
                            }
                        }
                    }
                    .padding()
                    .bold()
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .cornerRadius(8)
                    .padding(.top)
                    .disabled(passphraseManager.isAppLocked)
                    .opacity(passphraseManager.isAppLocked ? 0.4 : 1)
                }
            }

            Spacer()
        }
        .padding(.horizontal)
        .navigationBarTitle(account.name ?? "", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton {
            presentationMode.wrappedValue.dismiss()
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    authenticateWithSystem { success in
                        if success && !passphraseManager.isAppLocked {
                            showingEditView.toggle()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditAccountView(account: account)
        }
        .overlay(
            VStack {
                Spacer()
                if showCopiedToast {
                    Text(copiedLabelText)
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.green)
                        .clipShape(Capsule())
                        .transition(.opacity)
                        .padding(.bottom, 30)
                }
            }
        )
        .onChange(of: passphraseManager.isAppLocked) { locked in
            if locked {
                revealCredentials = false
                decryptedUsername = ""
                decryptedPassword = ""
            }
        }
    }

    private func credentialRow(icon: String, value: String, masked: Bool, copyAction: @escaping () -> Void) -> some View {
        HStack(spacing: 10) {
            Text(icon)
                .frame(width: 30, alignment: .leading)

            ZStack(alignment: .leading) {
                Text(bulletMask)
                    .font(sharedFont)
                    .italic()
                    .foregroundColor(.gray)
                    .opacity(masked ? 0.6 : 0)

                Text(value)
                    .font(sharedFont)
                    .italic()
                    .foregroundColor(.gray)
                    .opacity(masked ? 0 : 0.6)
            }
            .frame(minWidth: 200, alignment: .leading)

            if !masked {
                Button(action: copyAction) {
                    Image(systemName: "doc.on.doc")
                        .foregroundColor(.blue)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func copyToClipboard(_ text: String, _ label: String) {
        UIPasteboard.general.string = text
        copiedLabelText = label
        withAnimation {
            showCopiedToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                showCopiedToast = false
            }
        }
    }

    private func authenticateWithSystem(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        passphraseManager.isAuthenticating = true
        context.localizedFallbackTitle = "Use Passcode"

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: "Authenticate to reveal credentials") { success, _ in
                DispatchQueue.main.async {
                    passphraseManager.isAuthenticating = false
                    completion(success)
                }
            }
        } else {
            DispatchQueue.main.async {
                passphraseManager.isAuthenticating = false
                completion(false)
            }
        }
    }
}

