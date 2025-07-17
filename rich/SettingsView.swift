//
//  SettingsView.swift
//  rich
//
//  Created by snow on 2025/7/17.
//

import SwiftUI

@MainActor
@Observable
final class SettingsViewModel {
    func signOut() throws {
        try AuthManager.shared.signOut()
    }
}

struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        List {
            Button("Sign Out") {
                Task {
                    do {
                        try viewModel.signOut()
                        showSignInView = true
                    } catch {
                        print("Sign Out Error in SettingsView \(error)")
                    }
                }
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(.primary.opacity(0.9))
            .cornerRadius(30)
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}
