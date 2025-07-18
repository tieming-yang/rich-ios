//
//  SignInEmailView.swift
//  rich
//
//  Created by snow on 2025/7/17.
//

import SwiftUI

@Observable
@MainActor
final class SignInWithEmailViewModel {
    var email: String = ""
    var password: String = ""

    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Sign Up Error")
            return
        }

        let returnedUserData = try await AuthManager.shared.createUser(
            email: email,
            password: password
        )
        print("Created user: \(returnedUserData)")
    }

    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("Sign In Error")
            return
        }

        let signInUserData = try await AuthManager.shared.signInUser(
            email: email,
            password: password

        )
        print("Sign In user: \(signInUserData)")
    }
}

struct SignInEmailView: View {
    @State private var viewModel = SignInWithEmailViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.primary)
                }

            SecureField("Password", text: $viewModel.password)
                .padding()
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.primary)
                }

            Button {
                Task {
                    do {
                        try await viewModel.signUp()
                        showSignInView = false
                        return
                    } catch {
                        print("❌ Sign Up Error: \(error)")
                    }

                    do {
                        try await viewModel.signIn()
                        showSignInView = false
                        print("✅ Sign In Successfully")
                        return
                    } catch {
                        print("❌ Sign In Error: \(error)")
                    }
                }

            } label: {
                Text("Sign In")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(.primary.opacity(0.9))
                    .cornerRadius(30)
            }
            .padding(.top)

        }
        .padding()
        .navigationTitle("Sign In With Email")
    }
}

#Preview {
    NavigationStack {
        SignInEmailView(showSignInView: .constant(false))
    }
}
