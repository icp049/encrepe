
import Foundation
import CoreData

class DataController: ObservableObject{
    let container  = NSPersistentContainer(name: "AccountModel")

    init(){
        container.loadPersistentStores {desc, error in
        if let error = error {
            print("Failed to load the data \(error.localizedDescription)")
        }
        }
    }


   func save(context: NSManagedObjectContext){
    do {
        try context.save()
        print("Data saved")
    } catch {
        print("We can NOT save data...")
    }

   }

    func addAccount(name: String, username: String, password: String, context: NSManagedObjectContext){
    
    let account = Account(context:context)
    account.id = UUID()
    account.date = Date()
    account.name = name
    account.username = username
    account.password = password
    
    save(context:context)

   }

    func editAccount(account: Account, name: String, username: String, password: String, context:NSManagedObjectContext){
    account.date = Date()
    account.name = name
    account.username = username
    account.password = password

    save(context:context)
   }

}



