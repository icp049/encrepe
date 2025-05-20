import SwiftUI

struct EditAccountView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var passphraseManager: PassphraseManager

    var account: FetchedResults<Account>.Element

    @State private var name = ""
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        Form {
            Section {
                TextField("Account", text: $name)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()

                TextField("Username/Email", text: $username)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()

                TextField("Password", text: $password)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            }
            .onAppear {
                name = account.name ?? ""
                if let key = passphraseManager.encryptionKey {
                    username = EncryptionHelper.decrypt(account.username ?? Data(), using: key) ?? "Decryption error"
                    password = EncryptionHelper.decrypt(account.password ?? Data(), using: key) ?? "Decryption error"
                }
            }

            HStack {
                Spacer()
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
                .padding()
                Spacer()
            }
        }
    }
}

