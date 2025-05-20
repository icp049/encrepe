import SwiftUI
import LocalAuthentication

struct AccountView: View {
    @State private var showingEditView = false
    @State private var revealCredentials = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme

    let account: Account

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                HStack {
                    Image("yellowcard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Text(revealCredentials ? "\(account.username ?? "Not Available")" : getCensoredText())
                        .italic()
                        .animation(.easeInOut(duration: 0.3), value: revealCredentials)
                        .foregroundColor(.gray).opacity(0.6)
                }

                HStack {
                    Image("yellowkey")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                    Text(revealCredentials ? "\(account.password ?? "Not Available")" : getCensoredText())
                        .italic()
                        .animation(.easeInOut(duration: 0.3), value: revealCredentials)
                        .foregroundColor(.gray).opacity(0.6)
                }

                if !revealCredentials {
                    Button("Decrypt") {
                        authenticateWithSystem { success in
                            if success {
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
                }
            }
            .padding(.top, 30)
        }
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
    }

    // ✅ The ideal authentication policy
    func authenticateWithSystem(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        context.localizedFallbackTitle = "Use Passcode"

        // This will try biometrics first, then passcode
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: "Authenticate to reveal credentials") { success, _ in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            // Nothing available
            DispatchQueue.main.async {
                completion(false)
            }
        }
    }

    func getCensoredText() -> String {
        return "********************"
    }
}

