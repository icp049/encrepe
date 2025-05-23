import SwiftUI
import CoreData
import LocalAuthentication

struct HomeView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var passphraseManager: PassphraseManager

    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) var accounts: FetchedResults<Account>

    @State private var showingAddView = false
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            ZStack {
                // Background tap gesture to dismiss keyboard
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }

                VStack(alignment: .leading) {

                    // 🔍 Search Field UI
                    ZStack(alignment: .leading) {
                        TextField("Search for your accounts...", text: $searchText)
                            .foregroundColor(.primary)
                            .padding(.leading, 35)
                            .padding(.vertical, 10)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)

                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(.leading, 10)
                    }
                    .frame(height: 40)
                    .padding([.top, .horizontal])

                    List {
                        ForEach(filteredAccounts, id: \.self) { account in
                            NavigationLink(destination: AccountView(account: account)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text(account.name ?? "Unnamed")
                                            .bold()
                                            .foregroundColor(colorScheme == .dark ? .white : .black)
                                            .font(.system(size: 15))

                                        Text("••••••••••••••")
                                            .foregroundColor(.gray)
                                            .opacity(0.6)
                                            .font(.system(.caption, design: .monospaced))

                                        if let date = account.date {
                                            Text(calcTimeSince(date: date))
                                                .foregroundColor(.gray)
                                                .font(.system(size: 10))
                                        }
                                    }
                                }
                            }
                        }
                        .onDelete(perform: deleteAccount)
                    }
                    .listStyle(.plain)
                }
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
                        Text("🔐")
                            .font(.system(size: 26))

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

    // MARK: - Account Search Filtering
    var filteredAccounts: [Account] {
        if searchText.isEmpty {
            return Array(accounts)
        } else {
            return accounts.filter { $0.name?.localizedCaseInsensitiveContains(searchText) ?? false }
        }
    }

    // MARK: - Delete
    private func deleteAccount(offsets: IndexSet) {
        withAnimation {
            offsets.map { accounts[$0] }
                .forEach(managedObjContext.delete)
            DataController().save(context: managedObjContext)
        }
    }
}

// Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, DataController().container.viewContext)
            .environmentObject(PassphraseManager())
    }
}
 
