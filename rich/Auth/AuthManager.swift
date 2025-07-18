//
//  AuthManager.swift
//  rich
//
//  Created by snow on 2025/7/17.
//

import FirebaseAuth
import Foundation

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?

    init(user: User) {
        self.uid = user.uid
        self.email = user.email
        // Use a string for Firebase type compatibility
        self.photoUrl = user.photoURL?.absoluteString
    }
}

enum AuthProviderOptions: String {
    case email = "password"
    case google = "google.com"
}

final class AuthManager {
    static let shared = AuthManager()
    private init() {}

    func getUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else {
            //TODO: Create custom errors
            throw URLError(.badServerResponse)
        }

        return AuthDataResultModel(user: user)
    }

    func getProvider() throws -> [AuthProviderOptions] {
        guard let providerData = Auth.auth().currentUser?.providerData else {
            throw URLError(.badServerResponse)
        }

        var providers: [AuthProviderOptions] = []

        for provider in providerData {
            if let option = AuthProviderOptions(rawValue: provider.providerID) {
                providers.append(option)
            } else {
                assertionFailure("Provider not supported: \(provider.providerID)")
            }

        }

        return providers
    }

    func signOut() throws {
        try Auth.auth().signOut()
        print("Signout Success")
    }

}

// MARK: Sign in email
extension AuthManager {
    @discardableResult
    func createUser(email: String, password: String) async throws
        -> AuthDataResultModel
    {
        let authDataResult = try await Auth.auth().createUser(
            withEmail: email,
            password: password
        )
        return AuthDataResultModel(user: authDataResult.user)
    }

    @discardableResult
    func signInUser(email: String, password: String) async throws
        -> AuthDataResultModel
    {
        let authDataResult = try await Auth.auth().signIn(
            withEmail: email,
            password: password
        )
        return AuthDataResultModel(user: authDataResult.user)
    }

    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(
            withEmail: email
        )
    }

    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.unknown)
        }

        try await user.updatePassword(to: password)
    }

    func updateEmail(email: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.unknown)
        }

        try await user.sendEmailVerification(beforeUpdatingEmail: email)
    }

}

// MARK: Sign in SSO
extension AuthManager {

    @discardableResult
    func signInWithGoogle(idToken: String, accessToken: String) async throws
        -> AuthDataResultModel
    {
        let credential = GoogleAuthProvider.credential(
            withIDToken: idToken,
            accessToken: accessToken
        )

        return try await signIn(credential: credential)
    }

    func signIn(credential: AuthCredential) async throws
        -> AuthDataResultModel
    {

        let authDataResult = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResult.user)
    }
}
