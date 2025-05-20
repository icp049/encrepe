import SwiftUI

struct AddAccountView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var passphraseManager: PassphraseManager

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

                HStack {
                    Spacer()

                    RUButton(title: "Add Account", background: .black) {
                        if let key = passphraseManager.encryptionKey {
                            DataController().addAccount(
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
}

