

import SwiftUI

struct AddAccountView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    

    @State private var name = ""
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
            Form {
                Section() {
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
                        
                        
                        RUButton(title: "Add Account", background:.black){
                            DataController().addAccount(
                                name: name,
                                username: username,
                                password: password,
                                context: managedObjContext)
                            dismiss()
                        }
                        .padding()
                        
                        
                        
                        
                   
                        Spacer()
                    }
                }
        }
    }
}

struct AddFoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddAccountView()
    }
}

