//
//  VerificationCheckView.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/13/23.
//

import SwiftUI

struct VerificationCheckView: View {
    @EnvironmentObject var authenticator: AuthenticationManager
    @State private var verifiedEmail: Bool = false
    private let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            if verifiedEmail {
                ChatView()
//                    .environmentObject(authenticator)
            } else {
                EmailVerificationAlertView(showAlert: $verifiedEmail)
            }
        }
        .onAppear {
            checkEmailVerificationStatus()
        }
        .onDisappear {
            timer.upstream.connect().cancel()
        }
        .onReceive(timer) { _ in
            checkEmailVerificationStatus()
        }
    }

    private func checkEmailVerificationStatus() {
        authenticator.checkEmailVerificationStatus { result in
            switch result {
            case .success(let isEmailVerified):
                verifiedEmail = isEmailVerified
            case .failure(let error):
                print("Error checking email verification status: \(error)")
            }
        }
    }
}
