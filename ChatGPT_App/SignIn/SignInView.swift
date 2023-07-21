//
//  SignInView.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/5/23.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var authenticator: AuthenticationManager
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        ZStack {
            MainBackgroundView()
            
            VStack(spacing: 20) {
                LazyVStack(spacing: 20) {
                    TextFieldView(placeholder: "Full Name", text: $viewModel.fullName)
                    
                    TextFieldView(placeholder: "Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .onChange(of: viewModel.email) { newValue in
                            if !newValue.isEmpty {
                                viewModel.hasTypedInEmail = true
                            }
                        }
                    
                    if !viewModel.isEmailValid() && viewModel.hasTypedInEmail {
                        Text("Please enter a valid email")
                            .foregroundColor(.white)
                            .font(.caption)
                            .padding(.horizontal)
                    }
                    
                    SecureFieldView(placeholder: "Password", text: $viewModel.password)
                        .onChange(of: viewModel.password) { newValue in
                            if !newValue.isEmpty {
                                viewModel.hasTypedInPassword = true
                            }
                        }
                    
                    if viewModel.hasTypedInPassword {
                        Text(viewModel.passwordRequirements)
                            .font(.caption)
                            .foregroundColor(viewModel.passwordRequirements.contains("met") ? .green : .white)
                            .multilineTextAlignment(.center)
                            .lineLimit(10)
                            .padding(.horizontal)
                    }
                    
                    ActionButton(title: "Sign Up") {
                        signUp()
                    }
                    .disabled(!viewModel.isSignUpButtonEnabled)
                    .opacity(viewModel.isSignUpButtonEnabled ? 1.0 : 0.5)
                    .padding(.top, 20)
                }
                .padding()
            }
            .padding()
            .background(
                RoundedRectangleBackgroundView()
            )
        }
        .navigationBarHidden(false)
        .navigationBarTitle("Sign Up")
        .navigationBarTitleDisplayMode(.large)
        .alert(isPresented: $viewModel.showErrorAlert) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            if (authenticator.auth.currentUser?.isEmailVerified ?? false) {
                authenticator.userSignedIn = true
            }
        }
    }
    
    func signUp() {
        if viewModel.isEmailValid() {
            authenticator.signIn(name: viewModel.fullName, email: viewModel.email, password: viewModel.password) { result in
                switch result {
                case .success(let success):
                    if success {
                        //sent email verification mail and succesfully added user to the database
//                        viewModel.isVerificationEmailSent = true
                    }
                case .failure(_):
                    viewModel.errorMessage = "Sign-in failed, please check your credentials and try again."
                    viewModel.showErrorAlert = true
                }
            }
        } else {
            viewModel.errorMessage = AuthError.invalidEmail.errorMessage
            viewModel.showErrorAlert = true
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
