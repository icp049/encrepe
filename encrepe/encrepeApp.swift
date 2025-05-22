import SwiftUI
import LocalAuthentication

@main
struct encrepeApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var dataController = DataController()
    @StateObject private var passphraseManager = PassphraseManager()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if passphraseManager.showingPrompt {
                    PassphrasePromptView(manager: passphraseManager)
                } else {
                    HomeView()
                        .environment(\.managedObjectContext, dataController.container.viewContext)
                        .environmentObject(passphraseManager)
                }

                if passphraseManager.isAppLocked {
                    LockView {
                        unlockApp()
                    }
                }
            }
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .inactive, .background:
                    if !passphraseManager.isAuthenticating {
                        passphraseManager.isAppLocked = true
                    }
                case .active:
                    if passphraseManager.isAppLocked && !passphraseManager.isAuthenticating {
                        unlockApp()
                    }
                default:
                    break
                }
            }
        }
    }

    func unlockApp() {
        let context = LAContext()
        var error: NSError?

        passphraseManager.isAuthenticating = true

        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication,
                                   localizedReason: "Unlock Encrepe") { success, _ in
                DispatchQueue.main.async {
                    passphraseManager.isAuthenticating = false
                    if success {
                        passphraseManager.isAppLocked = false
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                passphraseManager.isAuthenticating = false
            }
        }
    }
}

