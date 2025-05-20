//
//  PassphrasePromptView.swift
//  encrepe
//
//  Created by Ian Pedeglorio on 2025-05-20.
//
import SwiftUI

struct PassphrasePromptView: View {
    @ObservedObject var manager: PassphraseManager
    @State private var passphrase = ""

    var body: some View {
        VStack {
            Text("Enter your secure passphrase").font(.headline)
            SecureField("Passphrase", text: $passphrase)
                .textFieldStyle(.roundedBorder)
                .padding()

            if let error = manager.errorMessage {
                Text(error).foregroundColor(.red)
            }

            Button("Unlock") {
                manager.submitPassphrase(passphrase)
            }
            .padding(.top)
        }
        .padding()
    }
}
