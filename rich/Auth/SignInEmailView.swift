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

    //    func signUp() async throws {
    //        guard !email.isEmpty, !password.isEmpty else {
    //            print("No email or password found.")
    //            return
    //        }
    //
    //        let returnedUserData = try await AuthManager.shared.createUser(
    //            email: email,
    //            password: password
    //        )
    //        print("Created user: \(returnedUserData.uid)")
    //    }

    func signIn() {
        guard !email.isEmpty, !password.isEmpty else {
            print("Sign In Error: No email or password found.")
            return
        }

        Task {
            do {
                let returnedUserData = try await AuthManager.shared.createUser(
                    email: email,
                    password: password
                )
                print("Sign In Success: \(returnedUserData)")

            } catch {
                print("Sign in Error \(error)")
            }
        }

    }
}

struct SignInEmailView: View {
    @State private var viewModel = SignInWithEmailViewModel()

    var body: some View {
        VStack {
            TextField("Email...", text: $viewModel.email)
                .padding()
                .background(.secondary.opacity(0.3))
                .cornerRadius(30)

            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(.secondary.opacity(0.3))
                .cornerRadius(30)

            Button {

                //                        try await viewModel.signIn()
                //                                                showSignInView = false
                //                        return

                //                        print("Error \(error)")

                viewModel.signIn()
                //                        showSignInView = false

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
        SignInEmailView()
    }
}
