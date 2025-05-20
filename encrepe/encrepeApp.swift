import SwiftUI

@main
struct encrepeApp: App {
    @StateObject private var dataController = DataController()
    @StateObject private var passphraseManager = PassphraseManager()

    var body: some Scene {
        WindowGroup {
            if passphraseManager.showingPrompt {
                PassphrasePromptView(manager: passphraseManager)
            } else {
                ContentView()
                    .environment(\.managedObjectContext, dataController.container.viewContext)
                    .environmentObject(passphraseManager)
            }
        }
    }
}

