import SwiftUI
import CoreData
import LocalAuthentication

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var account: FetchedResults<Account>
    
    @State private var showingAddView = false

    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List {
                    ForEach(account) { account in
                        NavigationLink(destination: AccountView(account: account)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(account.name!)
                                        .bold()
                                        .foregroundColor(colorScheme == .dark ? .white : .black)
                                        .font(.system(size: 15))
                                    
                                    
                                    Text(String(repeating: "•", count: account.username?.count ?? 0))
                                        .foregroundColor(.gray).opacity(0.6)
                                    
                                    Text(String(repeating: "•", count: account.password?.count ?? 0))
                                        .foregroundColor(.gray).opacity(0.6)
                                    
                                    
                                 
                                        Text(calcTimeSince(date: account.date!))
                                            .foregroundColor(.gray)
                                            .font(.system(size: 10))
                                           
                                        
                                    
                                  
                                    
                                }
                            }
                            
                        }
                    }
                    .onDelete(perform: deleteAccount)
                }
                .listStyle(.plain)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddView.toggle()
                    } label: {
                        Label("Add Account", systemImage: "plus")
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    HStack {
                        Image("padlock")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                        
                        Text("Accounts")
                            .foregroundColor(.blue)
                            .font(.system(size: 22))
                    }
                }
            }
            .sheet(isPresented: $showingAddView) {
                AddAccountView()
            }
        }
        .navigationViewStyle(.stack)
    }
    
    // Deletes account at the current offset
    private func deleteAccount(offsets: IndexSet) {
        withAnimation {
            offsets.map { account[$0] }
                .forEach(managedObjContext.delete)
            
            // Saves to our database
            DataController().save(context: managedObjContext)
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



