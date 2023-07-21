//
//  LogInView.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/5/23.
//

import SwiftUI

struct LogInView: View {
    @EnvironmentObject var authenticator: AuthenticationManager
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var showErrorAlert = false
    
    var isLogInButtonEnabled: Bool {
        return !email.isEmpty && !password.isEmpty
    }
    
    var body: some View {
        ZStack {
            MainBackgroundView()
            
            VStack(spacing: 20) {
                VStack(spacing: 20) {
                    TextFieldView(placeholder: "Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textContentType(.username)
                    
                    SecureFieldView(placeholder: "Password", text: $password)
                    
                    ActionButton(title: "Log In") {
                        logIn { result in
                            switch result {
                            case .success(_):
                                // Success logIn
                                errorMessage = ""
                                showErrorAlert = false
                            case .failure(let error):
                                errorMessage = error.errorMessage
                                print(errorMessage)
                                showErrorAlert = true
                            }
                        }
                    }
                    .disabled(!isLogInButtonEnabled)
                    .opacity(isLogInButtonEnabled ? 1.0 : 0.5)
                    .padding(.top, 20)
                    
                    NavigationLink {
                        SignInView()
                    } label: {
                        Text("Don't have an account? Sign In")
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                    
                    // Forgot Password label
                    NavigationLink {
                        ResetPasswordView()
                    } label: {
                        Text("Forgot Password?")
                            .foregroundColor(.white)
                            .font(.subheadline)
                    }
                }
                .padding()
            }
            .padding()
            .background(
                RoundedRectangleBackgroundView()
            )
            .navigationBarHidden(false)
            .navigationBarTitle("LogIn")
            .navigationBarTitleDisplayMode(.large)
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func logIn(completion: @escaping (Result<Bool, AuthError>) -> Void) {
        authenticator.logIn(email: email, password: password) { result in
            completion(result)
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
