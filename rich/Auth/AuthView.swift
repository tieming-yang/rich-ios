//
//  AuthView.swift
//  rich
//
//  Created by snow on 2025/7/17.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleSignInSwift
import SwiftUI

@MainActor
@Observable
final class AuthViewModel {

    func signInWithGoogle() async throws {

        // 1. we need to find out the UI View Hierachy
        guard let topVC = Utilities.shared.getTopViewController() else {
            throw NSError(
                domain: "Can't find top view controller",
                code: 0,
                userInfo: nil
            )
        }
        print("topVC: \(topVC)")
        // Copied from https://firebase.google.com/docs/auth/ios/google-signin?authuser=0#implement_google_sign-in
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(
            withPresenting: topVC
        )

        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw NSError(
                domain: "AuthView/43 - Google Sign In Error: No Id Token",
                code: 0,
                userInfo: nil
            )
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString

        let _authUser = try await AuthManager.shared.signInWithGoogle(
            idToken: idToken,
            accessToken: accessToken
        )

        print("Sign In with Google Success: \(_authUser)")

    }
}

struct AuthView: View {
    @State private var viewModel = AuthViewModel()
    @Binding var showSignInView: Bool

    var body: some View {
        VStack {
            //            NavigationLink {
            //                SignInEmailView(showSignInView: $showSignInView)
            //            } label: {
            //                Text("Sign In with Email")
            //                    .font(.headline)
            //                    .foregroundStyle(.white)
            //                    .frame(maxWidth: .infinity)
            //                    .frame(height: 50)
            //                    .background(.primary)
            //                    .cornerRadius(30)
            //            }
            //

            Button {
                Task {
                    do {
                        try await viewModel.signInWithGoogle()
                        showSignInView = false
                    } catch {
                        print("Sign in with Google Error: \(error)")
                    }
                }
            } label: {
                Text("Sign In with Google")
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(.primary)
            .cornerRadius(30)

            Spacer()
        }
        .padding()
        .navigationTitle("Sign In")
    }
}

#Preview {
    NavigationStack {
        AuthView(showSignInView: .constant(false))
    }
}
