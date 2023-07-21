//
//  ResetPasswordView.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/12/23.
//

import SwiftUI

enum ResetStatus {
    case none
    case success
    case failure
}

struct ResetPasswordView: View {
    @State private var email: String = ""
    @State private var resetStatus: ResetStatus = .none
    @EnvironmentObject var authenticator: AuthenticationManager
    @State private var errorMessage: String = ""
    @State private var showingAlert: Bool = false
    
    var isResetButtonEnabled: Bool {
        return !email.isEmpty
    }
    
    var body: some View {
        ZStack {
            MainBackgroundView()
            VStack {
                Text("Please enter your email to reset the password")
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                TextField("Enter your email", text: $email)
                    .padding()
                    .background(Color(uiColor: .white))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .textContentType(.emailAddress)
                    .padding(.bottom, 20)
                
                Button(action: {
                    resetPassword()
                }) {
                    Text("Reset Password")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.16, green: 0.55, blue: 0.90), Color(red: 0.22, green: 0.29, blue: 0.60)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .disabled(!isResetButtonEnabled)
                .opacity(isResetButtonEnabled ? 1.0 : 0.5)
                
                switch resetStatus {
                case .success:
                    Text("Password reset email sent successfully")
                        .foregroundColor(.green)
                        .padding(.top)
                case .failure:
                    Text("Password reset error. Please try again.")
                        .foregroundColor(.red)
                        .padding(.top)
                default:
                    EmptyView()
                }
            }
            .padding()
            .padding()
            .background(
                RoundedRectangleBackgroundView()
            )
            .navigationTitle("Password Reset")
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    func resetPassword() {
        authenticator.resetPassword(email: email) { result in
            switch result {
            case .success:
                resetStatus = .success
            case .failure(_):
                resetStatus = .failure
                errorMessage = "There is no user record corresponding to this email."
                showingAlert = true
            }
        }
    }
}


struct ResetPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ResetPasswordView()
    }
}


