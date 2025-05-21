import Foundation
import CoreData
import CryptoKit

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "AccountModel")

    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("Failed to load the data \(error.localizedDescription)")
            }
        }
    }

    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved")
        } catch {
            print("We can NOT save data...")
        }
    }

    // 🔐 Add account with encryption
    func addAccount(name: String, username: String, password: String, key: SymmetricKey, context: NSManagedObjectContext) {
        let account = Account(context: context)
        account.id = UUID()
        account.date = Date()
        account.name = name

        // ✅ Encrypt first and store in variables
        guard let encryptedUsername = EncryptionHelper.encrypt(username, using: key),
              let encryptedPassword = EncryptionHelper.encrypt(password, using: key) else {
            print("❌ Encryption failed. Cannot save account.")
            return
        }

        // ✅ Assign encrypted data to Core Data object
        account.username = encryptedUsername
        account.password = encryptedPassword

        // 🪵 Debug logging
        #if DEBUG
        print("🟢 Saving account:")
        print("   Name: \(name)")
        print("   Encrypted username: \(encryptedUsername as NSData)")
        print("   Encrypted password: \(encryptedPassword as NSData)")

        // Optional: verify decryption
        if let decryptedUser = EncryptionHelper.decrypt(encryptedUsername, using: key),
           let decryptedPass = EncryptionHelper.decrypt(encryptedPassword, using: key) {
            print("   🔓 Decrypted username: \(decryptedUser)")
            print("   🔓 Decrypted password: \(decryptedPass)")
        }
        #endif

        // ✅ Save to Core Data
        save(context: context)
    }


    // ✏️ Edit account with re-encryption
    func editAccount(account: Account, name: String, username: String, password: String, key: SymmetricKey, context: NSManagedObjectContext) {
        account.date = Date()
        account.name = name
        account.username = EncryptionHelper.encrypt(username, using: key)
        account.password = EncryptionHelper.encrypt(password, using: key)

        save(context: context)
    }
}

