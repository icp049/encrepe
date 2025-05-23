import SwiftUI

struct EditAccountView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var passphraseManager: PassphraseManager

    var account: FetchedResults<Account>.Element

    @State private var name = ""
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false

    var body: some View {
        ZStack {
            // Dismiss keyboard on background tap
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    hideKeyboard()
                }

            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    // Account Name Field
                    TextField("Account", text: $name)
                        .padding()
                        .frame(height: 50)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.separator), lineWidth: 0.5)
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    // Username Field
                    TextField("Username / Email", text: $username)
                        .padding()
                        .frame(height: 50)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(.separator), lineWidth: 0.5)
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    // Password Field
                    ZStack(alignment: .trailing) {
                                           Group {
                                               if showPassword {
                                                   TextField("Password", text: $password)
                                               } else {
                                                   SecureField("Password", text: $password)
                                               }
                                           }
                                           .padding()
                                           .frame(height: 50)
                                           .background(Color(.secondarySystemBackground))
                                           .cornerRadius(12)
                                           .overlay(
                                               RoundedRectangle(cornerRadius: 12)
                                                   .stroke(Color(.separator), lineWidth: 0.5)
                                           )
                                           .autocapitalization(.none)
                                           .disableAutocorrection(true)

                                           Button(action: {
                                               withAnimation {
                                                   showPassword.toggle()
                                               }
                                           }) {
                                               Image(systemName: showPassword ? "eye.slash" : "eye")
                                                   .foregroundColor(.gray)
                                                   .padding(.trailing, 12)
                                           }
                                       }
                                   }
                .padding(.horizontal)
                .padding(.top, 40)

                // Update Button
                RUButton(title: "Update", background: .black) {
                    if let key = passphraseManager.encryptionKey {
                        DataController().editAccount(
                            account: account,
                            name: name,
                            username: username,
                            password: password,
                            key: key,
                            context: managedObjContext
                        )
                        dismiss()
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
        }
        .onAppear {
            name = account.name ?? ""
            if let key = passphraseManager.encryptionKey {
                username = EncryptionHelper.decrypt(account.username ?? Data(), using: key) ?? "Decryption error"
                password = EncryptionHelper.decrypt(account.password ?? Data(), using: key) ?? "Decryption error"
            }
        }
    }
}

