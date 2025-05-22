//
//  View+Extensions.swift
//  encrepe
//
//  Created by Ian Pedeglorio on 2025-05-22.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
