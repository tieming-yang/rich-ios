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

    func createUser(email: String, password: String) async throws
        -> AuthDataResultModel
    {
        let authDataResult = try await Auth.auth().createUser(
            withEmail: email,
            password: password
        )
        return AuthDataResultModel(user: authDataResult.user)
    }

    func signOut() throws {
        try Auth.auth().signOut()
        print("Signout Success")
    }
}
