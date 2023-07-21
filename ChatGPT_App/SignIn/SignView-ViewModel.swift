//
//  SignView-ViewModel.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/5/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

class SignInViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var errorMessage: String = ""
    @Published var showErrorAlert = false
    @Published var hasTypedInEmail = false
    @Published var hasTypedInPassword = false
    
    /// Determines if the Sign Up button is enabled based on the entered full name, email, and password.
    var isSignUpButtonEnabled: Bool {
        !fullName.isEmpty && !email.isEmpty && isPasswordValid()
    }
    
    /// Generates the password requirements message based on the entered password.
    var passwordRequirements: String {
        let requirements: [String] = [
            "At least 8 characters",
            "Contains at least one uppercase letter",
            "Contains at least one numerical digit",
            "Contains at least one special symbol or lowercase letter"
        ]
        
        var unmetRequirements: [String] = []
        
        if password.count < 8 {
            unmetRequirements.append(requirements[0])
        }
        
        if !password.contains(where: { $0.isUppercase }) {
            unmetRequirements.append(requirements[1])
        }
        
        if !password.contains(where: { $0.isNumber }) {
            unmetRequirements.append(requirements[2])
        }
        
        if !password.contains(where: { !$0.isLetter && !$0.isNumber }) {
            unmetRequirements.append(requirements[3])
        }
        
        if unmetRequirements.isEmpty {
            return "Password requirements met"
        } else {
            return "Password requirements: \(unmetRequirements.joined(separator: ", "))"
        }
    }
    
    /// Checks if the password meets the required criteria.
    /// - Returns: A boolean indicating if the password is valid.
    func isPasswordValid() -> Bool {
        // Check if the password is at least 8 characters long and contains at least one uppercase letter,
        // one numerical digit, and one special symbol or lowercase letter.
        let passwordRegex = "^(?=.*[A-Z])(?=.*[0-9])(?=.*[^A-Za-z0-9]).{8,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
    
    func isEmailValid() -> Bool {
        // Add an additional check for empty email
        guard !email.isEmpty else {
            return true
        }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
}
