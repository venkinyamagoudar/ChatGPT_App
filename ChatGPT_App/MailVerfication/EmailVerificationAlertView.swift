//
//  EmailVerificationAlertView.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/13/23.
//

import SwiftUI

struct EmailVerificationAlertView: View {
    @EnvironmentObject var authenticator: AuthenticationManager
    @Binding var showAlert: Bool
    
    var body: some View {
        ZStack{
            Color.red
                .ignoresSafeArea()
            VStack {
                Image(systemName: "envelope.badge")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .padding()
                
                Text("Please verify your email to access the chat.")
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .padding()
                
                Button(action: {
                    // Resend verification email logic
                    authenticator.sendVerificationEmail { result in
                        switch result {
                        case .success:
                            print("Email Sent")
                        case .failure(let error):
                            print("Email cannot be sent. Error: : \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Resend Verification Email")
                        .foregroundColor(.white)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.16, green: 0.55, blue: 0.90), Color(red: 0.22, green: 0.29, blue: 0.60)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(gradient: Gradient(colors: [Color.mint, Color(uiColor: .orange)]), startPoint: .top, endPoint: .bottom))
                    .shadow(radius: 10)
            )
            .padding()
            .onChange(of: authenticator.auth.currentUser!.isEmailVerified) { isEmailVerified in
                showAlert = isEmailVerified
            }
            .onAppear {
                showAlert = authenticator.auth.currentUser!.isEmailVerified
            }
        }
    }
}


struct EmailVerificationAlertView_Previews: PreviewProvider {
    static var previews: some View {
        EmailVerificationAlertView(showAlert: .constant(true))
    }
}
