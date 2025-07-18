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

    var authProviders: [AuthProviderOptions] = []

    func loadAuthProvders() {
        if let providers = try? AuthManager.shared.getProvider() {
            authProviders = providers
        }
    }

    func signOut() throws {
        try AuthManager.shared.signOut()
    }

    func resetPassword() async throws {
        let authUser = try AuthManager.shared.getUser()

        guard let email = authUser.email else {
            throw NSError(
                domain: "",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "Please login first"]
            )
        }

        try await AuthManager.shared.resetPassword(email: email)
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
            if viewModel.authProviders.contains(.email) {
                EmailSettingView()
            }

        }
        .onAppear {
            viewModel.loadAuthProvders()
        }
        .navigationBarTitle("Settings")
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}

struct EmailSettingView: View {
    @State private var viewModel = SettingsViewModel()

    var body: some View {
        Section {
            // TODO: Resent email sent alert
            Button("Reset Password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password reset email sent.")
                    } catch {
                        print("Reset Error in SettingsView \(error)")
                    }
                }
            }
        } header: {
            Text("Email")
        }
    }
}
