//
//  LockUnlockAnimationView.swift
//  encrepe
//
//  Created by Ian Pedeglorio on 2025-05-22.
//

import SwiftUI

struct LockUnlockAnimationView: View {
    @State private var isUnlocked = false
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: isUnlocked ? "lock.open.fill" : "lock.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(.blue)
                .scaleEffect(isUnlocked ? 1.1 : 1.0)
                .rotationEffect(.degrees(isUnlocked ? 0 : -10))
                .animation(.spring(response: 0.4, dampingFraction: 0.6), value: isUnlocked)

            Text("Unlocking...")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                isUnlocked = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                onComplete()
            }
        }
    }
}
