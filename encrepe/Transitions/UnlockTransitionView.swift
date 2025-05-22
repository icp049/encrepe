//
//  UnlockTransitionView.swift
//  encrepe
//
//  Created by Ian Pedeglorio on 2025-05-22.
//

import SwiftUI

struct UnlockTransitionView<Content: View>: View {
    @State private var showContent = false
    let content: () -> Content

    var body: some View {
        ZStack {
            if showContent {
                content()
                    .transition(.opacity)
            } else {
                LockUnlockAnimationView {
                    withAnimation(.easeInOut(duration: 0.4)) {
                        showContent = true
                    }
                }
            }
        }
    }
}
