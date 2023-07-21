//
//  Authentication.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/5/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import LocalAuthentication

protocol Authenticatable {
    func logIn(email: String, password: String, completion: @escaping (Result<Bool, AuthError>) -> Void)
    func signIn(name: String, email: String, password: String, completion: @escaping (Result<Bool, AuthError>) -> Void)
    func resetPassword(email: String, completion: @escaping (Result<Void, AuthError>) -> Void)
    func sendVerificationEmail(completion: @escaping (Result<Void, AuthError>) -> Void)
    func checkEmailVerificationStatus(completion: @escaping (Result<Bool, AuthError>) -> Void)
}

class AuthenticationManager: Authenticatable, ObservableObject {
    
    let auth = Auth.auth()
    let firebaseDatabase: FirebaseDatabaseServiceProtocol
    
    @Published var userSignedIn: Bool = false
    
    init(firebaseDatabase: FirebaseDatabaseServiceProtocol) {
        self.firebaseDatabase = firebaseDatabase
    }
    
    var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    /// Sends a verification email to the current user.
    /// - Parameter completion: Completion handler with the result of the email sending operation.
    func sendVerificationEmail(completion: @escaping (Result<Void, AuthError>) -> Void) {
        guard let user = auth.currentUser else {
            completion(.failure(.noCurrentUser))
            return
        }
        user.sendEmailVerification { error in
            if let error = error {
                completion(.failure(.unknownFirebaseError(error)))
            } else {
                completion(.success(()))
            }
        }
    }
    
    /// Checks the email verification status of the current user.
    /// - Parameter completion: Completion handler with the result indicating if the email is verified.
    func checkEmailVerificationStatus(completion: @escaping (Result<Bool, AuthError>) -> Void) {
        auth.currentUser?.reload(completion: { [weak self] error in
            if let error = error {
                completion(.failure(.unknownFirebaseError(error)))
                return
            }
            
            let isEmailVerified = self?.auth.currentUser?.isEmailVerified ?? false
            completion(.success(isEmailVerified))
        })
    }
    
    /// Logs in the user with the provided email and password.
    /// - Parameters:
    ///   - email: The user's email.
    ///   - password: The user's password.
    ///   - completion: Completion handler with the result of the login operation.
    func logIn(email: String, password: String, completion: @escaping (Result<Bool, AuthError>) -> Void) {
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                let authError = AuthError(error: error)
                completion(.failure(authError))
            } else if authResult != nil {
                DispatchQueue.main.async {
                    self?.userSignedIn = true
                }
                completion(.success(true))
            } else {
                completion(.failure(.unknownError))
            }
        }
    }
    
    /// Signs up a new user with the provided name, email, and password.
    /// - Parameters:
    ///   - name: The user's full name.
    ///   - email: The user's email.
    ///   - password: The user's password.
    ///   - completion: Completion handler with the result of the signup operation.
    func signIn(name: String, email: String, password: String, completion: @escaping (Result<Bool, AuthError>) -> Void) {
        auth.createUser(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                let authError = AuthError(error: error)
                completion(.failure(authError))
                return
            } else if authResult != nil {
                let uid = authResult!.user.uid
                let user = User(id: uid, fullname: name, email: email, messages: [])
                self?.firebaseDatabase.addUser(user: user)
                DispatchQueue.main.async {
                    self?.userSignedIn = true
                    self?.sendVerificationEmail(completion: { result in
                        switch result {
                        case .success:
                            completion(.success(true))
                        case .failure(let error):
                            completion(.failure(error))
                        }
                    })
                }
                completion(.success(true))
            } else {
                completion(.failure(.unknownError))
            }
        }
    }
    
    /// Sends a password reset email to the user with the provided email address.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - completion: Completion handler with the result of the password reset operation.
    func resetPassword(email: String, completion: @escaping (Result<Void, AuthError>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                let authError = AuthError(error: error)
                completion(.failure(authError))
            } else {
                completion(.success(()))
            }
        }
    }
}

enum AuthError: Error {
    case noCurrentUser
    case emailNotVerified
    case unknownError
    case invalidEmail
    case weakPassword
    case emailAlreadyInUse
    case wrongPassword
    case userNotFound
    case tooManyRequests
    case operationNotAllowed
    case unknownFirebaseError(Error)
    
    init(error: Error) {
        if let errorCode = AuthErrorCode.Code(rawValue: (error as NSError).code) {
            switch errorCode {
            case .invalidEmail:
                self = .invalidEmail
            case .weakPassword:
                self = .weakPassword
            case .emailAlreadyInUse:
                self = .emailAlreadyInUse
            case .wrongPassword:
                self = .wrongPassword
            case .userNotFound:
                self = .userNotFound
            case .tooManyRequests:
                self = .tooManyRequests
            case .operationNotAllowed:
                self = .operationNotAllowed
            default:
                self = .unknownFirebaseError(error)
            }
        } else {
            self = .unknownFirebaseError(error)
        }
    }
    
    var errorMessage: String {
        switch self {
        case .noCurrentUser:
            return "No current user found."
        case .emailNotVerified:
            return "Email is not verified."
        case .unknownError:
            return "An unknown error occurred."
        case .invalidEmail:
            return "Invalid email address."
        case .weakPassword:
            return "Weak password. Please choose a stronger password."
        case .emailAlreadyInUse:
            return "Email address is already in use."
        case .wrongPassword:
            return "Incorrect password."
        case .userNotFound:
            return "User not found."
        case .tooManyRequests:
            return "Too many requests. Please try again later."
        case .operationNotAllowed:
            return "Operation not allowed."
        case .unknownFirebaseError(let error):
            return error.localizedDescription
        }
    }
}

extension AuthenticationManager {
    
    var isFaceIDEnabled: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "isFaceIDEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isFaceIDEnabled")
        }
    }
    
    func isFaceIDAvailable() -> Bool {
        let context = LAContext()
        var error: NSError?
        
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) && context.biometryType == .faceID
    }
    
    private func authenticateWithFaceID(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        let reason = "Use Face ID to log in."
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
}
