

import SwiftUI

struct BackButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .foregroundColor(.blue)
                .imageScale(.large)
                .frame(width: 32, height: 32)
                .background(Color.clear)
        }
    }
}


