//
//  WelcomePage.swift
//  ChatGPT_App
//
//  Created by Venkatesh Nyamagoudar on 6/5/23.
//

import SwiftUI

struct WelcomeView: View {
    @EnvironmentObject var authenticator: AuthenticationManager
    @StateObject private var viewModel = WelcomeViewModel()
    
    var body: some View {
        ZStack {
            MainBackgroundView()
            VStack {
                Spacer()
                VStack {
                    Text(viewModel.typedText)
                        .font(.largeTitle)
                        .foregroundColor(viewModel.textColor)
                        .padding()
                }
                Spacer()
                VStack {
                    NavigationLink(destination: LogInView()) {
                        Text("Log In")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 300, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                    .padding(20)
                    NavigationLink(destination: SignInView()) {
                        Text("Sign Up")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(width: 300, height: 50)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(20)
                    .padding(.bottom, 20)
                }
                .padding()
                .background(
                    RoundedRectangleBackgroundView()
                )
                .navigationBarHidden(true)
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            viewModel.animateText()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
