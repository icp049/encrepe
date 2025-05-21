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

    // Toast State
    @State private var showCopiedToast = false
    @State private var copiedLabelText = ""

    // Shared styling
    let bulletMask = "•••••••••••••••••••••"
    let sharedFont = Font.system(size: 14, design: .monospaced)

    var body: some View {
        VStack {
            Spacer()

            VStack(spacing: 20) {
                // 🪪 Username Row
                HStack(spacing: 10) {
                    Text("🪪")
                        .frame(width: 30, alignment: .leading)

                    ZStack(alignment: .leading) {
                        Text(bulletMask)
                            .font(sharedFont)
                            .italic()
                            .foregroundColor(.gray)
                            .opacity(revealCredentials ? 0 : 0.6)

                        Text(decryptedUsername)
                            .font(sharedFont)
                            .italic()
                            .foregroundColor(.gray)
                            .opacity(revealCredentials ? 0.6 : 0)
                    }
                    .frame(minWidth: 200, alignment: .leading)

                    if revealCredentials {
                        Button {
                            UIPasteboard.general.string = decryptedUsername
                            copiedLabelText = "Username copied!"
                            withAnimation {
                                showCopiedToast = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showCopiedToast = false
                                }
                            }
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                }

                // 🔑 Password Row
                HStack(spacing: 10) {
                    Text("🔑")
                        .frame(width: 30, alignment: .leading)

                    ZStack(alignment: .leading) {
                        Text(bulletMask)
                            .font(sharedFont)
                            .italic()
                            .foregroundColor(.gray)
                            .opacity(revealCredentials ? 0 : 0.6)

                        Text(decryptedPassword)
                            .font(sharedFont)
                            .italic()
                            .foregroundColor(.gray)
                            .opacity(revealCredentials ? 0.6 : 0)
                    }
                    .frame(minWidth: 200, alignment: .leading)

                    if revealCredentials {
                        Button {
                            UIPasteboard.general.string = decryptedPassword
                            copiedLabelText = "Password copied!"
                            withAnimation {
                                showCopiedToast = true
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showCopiedToast = false
                                }
                            }
                        } label: {
                            Image(systemName: "doc.on.doc")
                                .foregroundColor(.blue)
                        }
                        .buttonStyle(.plain)
                    }
                }

                // 🔓 Decrypt Button
                if !revealCredentials {
                    Button("Decrypt") {
                        authenticateWithSystem { success in
                            if success, let key = passphraseManager.encryptionKey {
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
                        if success {
                            showingEditView.toggle()
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showingEditView) {
            EditAccountView(account: account)
        }

        // 🔔 Copied Toast at Bottom
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
    }

    // Biometric or passcode auth
    func authenticateWithSystem(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        context.localizedFallbackTitle = "Use Passcode"

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: "Authenticate to reveal credentials") { success, _ in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }
}

