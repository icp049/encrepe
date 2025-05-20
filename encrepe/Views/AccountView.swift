import SwiftUI
import LocalAuthentication

struct AccountView: View {
    @State private var showingEditView = false
    @State private var revealCredentials = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    
    @State private var unlocked = false
    @State private var text = "LOCKED"
    
    
    

    let account: Account

    var body: some View {
        VStack{
            VStack {
                VStack {
                    HStack {
                        Image("yellowcard")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)

                        Text(revealCredentials ? "\(account.username ?? "Not Available")" : getCensoredText())
                            .italic()
                            .animation(.easeInOut(duration: 0.5))
                            .foregroundColor(.gray).opacity(0.6)
                            
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)

                VStack {
                    HStack {
                        Image("yellowkey")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        Text(revealCredentials ? "\(account.password ?? "Not Available")" : getCensoredText())
                            .italic()
                            .animation(.easeInOut(duration: 0.5))
                            .foregroundColor(.gray).opacity(0.6)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)

                VStack {
                    Button("Decrypt") {
                        authenticateWithFaceID { success in
                            if success {
                                withAnimation {
                                    revealCredentials.toggle()
                                }
                            }
                        }
                    }
                    .padding()
                    .bold()
                    .background(colorScheme == .dark ? .white : .black)
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                    .opacity(revealCredentials ? 0 : 1)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .frame(maxWidth: .infinity, alignment: .center)
                }
               
                .padding(.top,25)
            }
        }
        .navigationBarTitle(account.name ?? "", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: BackButton { presentationMode.wrappedValue.dismiss() })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    authenticateWithFaceID { success in
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
        
        context.localizedFallbackTitle = "Use Passcode"

        if context.canEvaluatePolicy(.deviceOwnerAuthentication,
                                     error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: "AUthenticate to reveal credentials") { success, authenticationError in

                DispatchQueue.main.async {
                               if success {
                                   text = "UNLOCKED"
                                   completion(true)
                               } else {
                                   text = "Authentication failed"
                                   completion(false)
                               }
                           }
                       }
        } else {
            text = "Biometric authentication is not available"
            completion(false)
        }
    }

    func getCensoredText() -> String {
        return "********************"
    }

    
    
 
    
}

//i need to do something here so that it retries the faceID

