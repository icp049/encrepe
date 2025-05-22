import SwiftUI

struct LockView: View {
    var unlockAction: () -> Void

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Image(systemName: "lock.shield")
                    .font(.system(size: 60))
                    .foregroundColor(.gray)

                Text("App Locked")
                    .font(.title3)
                    .foregroundColor(.gray)

              
            }
        }
    }
}

