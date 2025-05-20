

import SwiftUI

struct EditAccountView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var account: FetchedResults<Account>.Element
    
    @State private var name = ""
    @State private var username = ""
    @State private var password = ""
    
    
    var body: some View {
        Form {
            Section() {
                TextField("\(account.name!)", text: $name)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                
                TextField("\(account.username!)", text: $username)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                
                TextField("\(account.password!)", text: $password)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                
                    .onAppear {
                        name = account.name!
                        username = account.username!
                        password = account.password!
                        
                    }
               
                
                HStack {
                    Spacer()
                    
                    RUButton(title: "Update", background:.black){
                        DataController().editAccount(account: account, name: name, username: username, password: password, context: managedObjContext)
                        dismiss()
                        
                    }
                    .padding()
                    Spacer()
                }
            }
        }
    }
}


